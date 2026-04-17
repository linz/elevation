# New Zealand Elevation TIFF Specification

Applies to Digital Elevation Models, Digital Surface Models and Hillshades published in s3://nz-elevation after being processed by Toitū Te Whenua Land Information New Zealand.

For data processing scripts, see [`linz/topo-imagery`](https://github.com/linz/topo-imagery).  
For workflow configuration, see [`linz/topo-workflows`](https://github.com/linz/topo-workflows).  

## File Format

| Property | Value |
|---|---|
| Container | GeoTIFF (`.tiff`) |
| Profile | Cloud-Optimised GeoTIFF (COG) |
| GDAL Driver | `COG` (`-of COG`) |

A summary of Cloud-Optimised GeoTIFF characteristics is provided [in the GDAL docs](https://github.com/OSGeo/gdal/pull/3487).

## Coordinate Reference Systems

| Type | Name | EPSG Code |
|---|---|---|
| Projection | New Zealand Transverse Mercator 2000 (NZTM2000) | 2193 |
| Vertical Datum | New Zealand Vertical Datum 2016 (NZVD2016) | 7839 |

Each TIFF contains the spatial reference information for NZTM2000. NZVD2016 is not recorded in the GeoTIFF metadata.

## Spatial Resolution

1m for all LiDAR-sourced DEMs, DSMs and Hillshades.  
s3://nz-elevation also contains a [contour-derived DEM](stac/new-zealand/new-zealand-contour) that is 8m spatial resolution.

## Band Configuration

| Data Type | Bands | Bit Depth | Colour Interpretation | Nodata | Interleave |
|---|---|---|---|---|---|
| DEMs/DSMs | 1 (elevation) | `float32` | `Gray` | `-9999` | `Band` |
| Hillshade | 1 (greyscale) | `uint8` | `Gray` | `0` | `Band` |

No alpha band is used for elevation data.

## COG Driver Options

The following [GDAL COG driver creation options](https://gdal.org/en/stable/drivers/raster/cog.html#creation-options) are applied to all TIFFs:

| GDAL Creation Option | Value | Notes |
|---|---|---|
| `-co BLOCKSIZE` | `512` | 512×512 pixel tiles (default) |
| `-co NUM_THREADS` | `ALL_CPUS` | Use all available CPUs for compression, overview generation, etc |
| `-co SPARSE_OK` | `TRUE` | Omit empty tiles (null byte) rather than writing blank data |
| `-co BIGTIFF` | `NO` | Classic TIFF only (GDAL will raise an error if output exceeds 4 GB and we target approx 1 GB TIFF sizes via automated tiling) |
| `-co OVERVIEWS` | `IGNORE_EXISTING` | Always regenerate overviews (never build from pre-existing lossy overviews) |
| `-co STATISTICS` | `YES` | Compute and embed raster statistics (ensures that GIS software can immediately accurately display the data) |

## Compression

### DEMs/DSMs - `LERC`

| GDAL Creation Option | Value | Notes |
|---|---|---|
| `-co COMPRESS` | `LERC` | [LERC compression](https://github.com/esri/lerc) provides control over the maximum error per-pixel |
| `-co MAX_Z_ERROR` | `0.001` | Maximum full-resolution error of 1mm |
| `-co MAX_Z_ERROR_OVERVIEW` | `0.1` | Maximum overview error of 10cm |
| `-mo AREA_OR_POINT` | `Area` | Forced to Area for consistency (input DEMs and DSMs vary) |
| `-a_nodata` / `--nodata` | `-9999` | Explicit nodata value set on all bands |

LERC is a near-lossless compression allowing a configurable per-pixel Z error (can also be completely lossless, but this removes one of the main advantages of LERC). The 1mm full-resolution error is well within the ~20cm vertical accuracy of the source LiDAR data. Overview error is relaxed to 10cm as overviews are used for visualisation only.

### Hillshades - `ZSTD`

| GDAL Creation Option | Value | Notes |
|---|---|---|
| `-co COMPRESS` | `ZSTD` | [ZSTD compression](https://github.com/facebook/zstd) is a high-performance, fast, lossless compression algorithm |
| `-co LEVEL` | `17` | Highest compression level that produces a significantly smaller file size (at the cost of slower compression, but that is okay for our use-cases) |
| `-co PREDICTOR` | `2` | Horizontal differencing predictor |
| `-co OVERVIEW_COMPRESS` | `ZSTD` | ZSTD compression for overviews as well |
| `-co OVERVIEW_RESAMPLING` | `LANCZOS` | Lanczos resampling for overview generation |

## File Naming Convention

Output files are named using the LINZ tile index grid name, e.g. `BK27_1000_0101.tiff`.

Individual 1m resolution LiDAR survey outputs are tiled to the [NZ 1:10k Tile Index](https://data.linz.govt.nz/layer/104690).  
The 8m contour-derived DEM and combined national DEM, DSM and Hillshade datasets are tiled to the [NZ 1:50k Tile Index](https://data.linz.govt.nz/layer/104687).

## GDAL Contributions

Toitū Te Whenua Land Information New Zealand has paid for the following contributions to GDAL:
- [`-of COG` driver](https://github.com/OSGeo/gdal/pull/1621), now the de facto raster data file format for geospatial data in cloud storage
- [`-co MAX_Z_ERROR_OVERVIEW`](https://github.com/OSGeo/gdal/pull/8394) option, saving us up to ~15% file size for elevation data with overviews

Along with [ongoing maintenance sponsorship](https://gdal.org/en/stable/sponsors/index.html).

If you benefit from any of these tools, please also consider sponsoring GDAL.
