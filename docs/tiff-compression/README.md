# Elevation compression and bulk distribution

## TLDR

Toitū Te Whenua has decided to store all its DEM and DSM as `lerc` Cloud Optimized GeoTIFFs in `s3://nz-elevation`

## Background

Toitū Te Whenua (LINZ) holds DEM (Digital Elevation Model) and DSM (Digital Surface Model) data for [most of New Zealand](https://www.linz.govt.nz/products-services/data/types-linz-data/elevation-data).

this data is delivered to LINZ as 1M GeoTiffs tiled into [1:1000](https://data.linz.govt.nz/layer/104692-nz-11k-tile-index/) tiles.

- [Waikato Lidar 1m DSM (2021)](https://data.linz.govt.nz/layer/113202-waikato-lidar-1m-dsm-2021/).
- [Taranaki LiDAR 1m DEM (2021)](https://data.linz.govt.nz/layer/107436-taranaki-lidar-1m-dem-2021/)

LINZ is required to store the elevation data in a safe and secure manner while also providing access to the data.

## Goals

As the data is stored in [AWS S3](https://aws.amazon.com/s3/) every GB of data stored costs LINZ [$0.0025 USD / month](https://aws.amazon.com/s3/pricing/?nc=sn&loc=4), to reduce costs for new zealand the imagery needs to be compressed to ensure cost efficient storage.

This data is large and will also be accessed remotely it should be stored in a cloud optimized format so users can extract only the parts of the data they need, [Cloud optimised geotiff (COG)](https://www.cogeo.org/) without downloading the entire TIFF.

As the DEM/DSM is 1M resolution and tiled at 1:1000, the resulting tiffs are 720x480 pixels and approximately 1.4MB uncompressed each, a single survey is 10,000s of files. To provide a better experience for users wanting to access large areas of New Zealand the GeoTiffs need to be and re-tiled into larger tiffs.

Files should be at least 10MB and ideally >100MB to allow efficient access from cloud storage.

Files should be supported by common processing tools such as [QGIS](https://qgis.org/en/site/), [GDAL](https://gdal.org/) and [ArcGIS PRO](https://www.esri.com/en-us/arcgis/products/arcgis-pro/overview) where they can be converted into other formats for additional processing.

LINZ uses GDAL for processing [COGs](https://gdal.org/drivers/raster/cog.html) which limits the compression types to LZW, DEFLATE, LERC and ZSTD.

Stacked lerc compression was not tested due to increased testing complexity and minimal gains (LERC_ZSTD z20 was only 20MB smaller than a LERC 1300MB COG.)

## Compression testing

GDAL provides a two options for most compression type

- Compression Level
- Predictor (none), Predictor 2 (Integer data type) or 3 (floating-point predictor)

LERC has additional options for adjusting how much error is allowed, as the datasets generally have a ~20cm vertical accuracy, to keep the accuracy high only small amounts of allowed z error were tested (<5mm);

- ZSTD (66 Tests)
  - Predictor NO/1/2
  - Level 1-22
- Deflate (27 Tests)
  - Predictor NO/1/2
  - level 1-9
- LZW (3 Tests)
  - Predictor NO/1/2
- LERC (5 Tests)
  - max z error: 0.1mm, 0.5mm, 1mm, 2mm, 5mm

Testing data was selected from [CF15](https://data.linz.govt.nz/data/?mv.basemap=Streets&mv.content=layer.104687.color:003399.opacity:100,layer.109627.opacity:100&mv.zoom=9&mv.centre=169.8493143938876,-45.98894052690091) in [Otago - Coastal Catchments LiDAR 1m DEM (2021)](https://data.linz.govt.nz/layer/109627-otago-coastal-catchments-lidar-1m-dem-2021/) as it provided a mix of flat and hilly regions. which resulted in 2,999 source tiff files approximately 3.4GB

to provide a somewhat reproducible result A docker container [`gdal-ubuntu-small-3.7.0`](https://github.com/OSGeo/gdal/pkgs/container/gdal/91692621?tag=ubuntu-small-3.7.0) was used

### Process

Each test was run multiple times in a random order then the summation of all results was created.

1. A VRT of all input files was made as the input for all tests

```bash
gdalbuildvrt cf15.vrt input/DEM_CF15_*
```

2. A test case was run and timed

```bash
docker run \
    -v tiffs-path:/input \
    ghcr.io/osgeo/gdal:ubuntu-small-3.7.0 \
    gdal_translate \
        -of COG \
        -co num_threads=all_cpus \
        -co sparse_ok=true \
        -co compression=${compression} \
        # options set per compression type
        -co level=${level} \  # (zstd,deflate) if level was set
        -co predictor=${predictor} \  # (zstd,deflate,lzw)
        -co max_z_error=${max_z_error} \  # (lerc)
    /input/input_tiff.vrt
    /output/cf15-${compression}_predictor-${precdictor}_level-${level}_error-${error}.tiff
```

## Results

A full table of results can be found in the [output.tsv](./compression-results.tsv)

Key results

| Id                          | File Size (mb) | Duration for 5 runs (ms) |
| --------------------------- | -------------- | ------------------------ |
| base                        | 3456.00        | 0                        |
| lzw_predictor-2             | 2686.27        | 190926                   |
| deflate_predictor-2_level-9 | 1982.15        | 208897                   |
| zstd_predictor-2_level-17   | 1858.77        | 469185                   |
| lerc_z-error-0.001          | 1319.11        | 192573                   |

LERC is by far the best compression and speed for converting the DEMS into COGs. if having a minor (1mm) error is allowed it is a huge savings.

As most of this work is for cost reduction for storage and egress of data, what level of cost reduction would this have for 1TB of input data.

With the current [AWS S3 pricing](https://aws.amazon.com/s3/pricing/) the following metrics were used

Standard Access - used for frequently accessed data

- $0.025 / GB / month = $300 / TB /Year

Infrequent Access - used for infrequently accessed data (most of our DEMs would fit into this category)

- $0.0138 / GB / month = $165 / TB / Year

Egress - Cost to send the data out of AWS

- $0.114 / GB = $114.00 / TB

| Id                          | Cost/TB/Year (Standard) | Cost/TB/Year (Infrequent) | Egress (1 copy downloaded) |
| --------------------------- | ----------------------- | ------------------------- | -------------------------- |
| base                        | $300.00                 | $165.60                   | $114.00                    |
| lzw_predictor-2             | $233.18                 | $128.71                   | $88.61                     |
| deflate_predictor-2_level-9 | $172.06                 | $94.78                    | $65.38                     |
| zstd_predictor-2_level-17   | $161.35                 | $89.06                    | $61.31                     |
| lerc_z-error-0.001          | $114.50                 | $63.20                    | $45.51                     |

So using LERC (1mm) for 1TB of input data would result in approx $190 USD / year in storage costs savings, and $70 in savings for every copy of the data that was egressed out of AWS.

## Hillshade Compression

There are Hillshade TIFFs in `s3://nz-elevation/` in addition to the DEM and DSM TIFFs. These hillshades don't contain elevation values, they use the elevation data and a sun position to shade particular pixels, providing a visualisation of the terrain. The standard output for a hillshade algorithm is a single-band (greyscale) output, so the data within the TIFF is very different and compression method rationale is not identical.

Indicative output size when compressing [BQ26, DEM Hillshade - Igor](https://nz-elevation.s3-ap-southeast-2.amazonaws.com/new-zealand/new-zealand/dem-hillshade-igor/2193/BQ26.tiff) with various lossless compression methods is:

| Id                          | File Size (mb) |
| --------------------------- | -------------- |
| webp                        | 367            |
| lerc                        | 478            |
| zstd                        | 609            |
| lzw                         | 679            |

WEBP compression requires storing the hillshade with 3 bands rather than 1 band, so we have ruled out this option as it deviates from the standard hillshade output that is expected.

LERC compression has therefore also been chosen for the hillshades TIFFs in `s3://nz-elevation/`.

## LERC support in GDAL/QGIS on Ubuntu Linux 22.04 Long Term Support (LTS)

LERC support is included in GDAL on Ubuntu Linux 22.10 and above, including 24.04 LTS (release date April 2024).

To enable support for LERC on Ubuntu Linux 22.04 and earlier, GDAL needs to be recompiled.

Instructions:

```bash

# Need GCC
sudo apt-get install build-essential

# Need PROJ, WEBP, ZSTD libs
sudo apt-get install libproj-dev
sudo apt-get install libwebp-dev
sudo apt-get install libzstd-dev

# Download GDAL for specific QGIS version you already have installed
# e.g. QGIS 3.22.4 uses GDAL 3.4.1
wget -c http://download.osgeo.org/gdal/3.4.1/gdal-3.4.1.tar.gz
tar -xvzf gdal-3.4.1.tar.gz
cd gdal-3.4.1
./configure --with-geotiff=internal --with-rename-internal-libgeotiff-symbols=yes --with-libtiff=internal --with-rename-internal-libtiff-symbols=yes --with-sqlite3 --with-proj=yes --with-python --with-hide-internal-symbols=yes

# Compile - takes a lot of time...
make -j$(nproc)

# Install
sudo make install

# Set variables
echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> ~/.profile
echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> ~/.bashrc
GDAL_DATA="/usr/local/share/gdal"
sudo ldconfig

```
