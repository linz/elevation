# Elevation Dataset Naming Conventions

Elevation dataset titles and S3 paths are constructed from metadata about each elevation survey so that they will be consistent and human readable. Elevation is stored according to the majority region that each dataset covers.

## Elevation Dataset Titles

The elevation dataset title is constructed from metadata that is entered when an elevation dataset is processed.

```
<region>[ - <geographic_description>?] LiDAR <gsd>m <geospatial_category> (<start_year>[-<end_year>?])[ - <lifecycle>?]
```

## Elevation Dataset S3 Paths

The elevation dataset S3 path is also constructed from similar metadata.

```
<region>/
  <geographic_description|region>_<start_year>[-<end_year>?]/
    <product>_<gsd>m/
      <crs>/
```

### S3 Path Restrictions

#### Characters

The path is restricted to a limited set of characters (a-z, A-Z, 0-9, -, \_ ) and no whitespace.

#### Macrons

When a name contains macrons "Ōtorohanga" the macron is removed from the path but retained in the STAC Collection's Title / Description.

#### Apostrophes

Where a name contains an apostrophe "Hawke's Bay" the apostrophe is removed from the path but retained in the STAC Collection's Title / Description.

## Title and S3 Path Components

### `crs`

EPSG Code for the coordinate reference system of the elevation data. Generally this is [`2193`](https://epsg.io/2193) as it is the primary projection for most of LINZ's elevation data.

### `geographic_description`

This is free text and at the elevation data maintainers discretion. A specific city or sub-region or event name may be used to help describe the elevation data capture area. The [Gazetteer](https://gazetteer.linz.govt.nz/) is referenced to ensure official names with correct spelling are used. If the region has full coverage, then the geographic description can be empty and the region name will be repeated.

### `geospatial_category`

A general categorisation of elevation data held within our archive that includes the following possible values:

- DEM `dem`
- DSM `dsm`

### `gsd`

The GSD or spatial resolution is the area covered on the ground by a single pixel. This is stored in metadata in metres with no trailing zeros after the decimal point.

### `lifecycle`

If `lifecycle = preview` then ` - Draft` is appended to the end of the elevation dataset title. 

### `product`

Elevation data product type, currently either `dem` or `dsm`.

### `region`

Is taken from a list of regions:

- Antarctica `antarctica`
- Auckland `auckland`
- Bay of Plenty `bay-of-plenty`
- Canterbury `canterbury`
- Northland `northland`
- Gisborne `gisborne`
- Global `global`
- Hawke's Bay `hawkes-bay`
- Manawatū-Whanganui `manawatu-whanganui`
- Marlborough `marlborough`
- Nelson `nelson`
- New Zealand `new-zealand`
- Otago `otago`
- Pacific Islands `pacific-islands`
- Southland `southland`
- Taranaki `taranaki`
- Tasman `tasman`
- Waikato `waikato`
- Wellington `wellington`
- West Coast `west-coast`

### `start_year` and `end_year`

In both cases, the full four digits should be used. If the elevation dataset was entirely captured within one year, then only a `start_year` is provided.

As elevation data can be updated after it is "named" for initial processing the `end_year` or lack of an `end_year` may be incorrect in the S3 Path. It is best to use this as a rough guideline and then use the STAC Collection for a more precise capture timeframe.

## Examples

1m DSM covering Upper Hutt City in the Wellington region captured in 2021

```
Title: Wellington - Upper Hutt City LiDAR 1m DSM (2021)
Path: s3://nz-elevation/wellington/upper_hutt_city_2021/dsm_1m/2193/collection.json
```

1m DEM covering the Hawke's Bay region captured in 2020-2021 (apostrophe removed in elevation dataset path)

```
Title: Hawke's Bay LiDAR 1m DEM (2020-2021)
Path: s3://nz-elevation/hawkes-bay/hawkes-bay_2020-2021/dem_1m/2193/collection.json
```

1m DEM covering Kaikōura in the Canterbury region captured in 2016 (macron removed in elevation dataset path)

```
Title: Canterbury - Kaikōura LiDAR 1m DEM (2016)
Path: s3://nz-elevation/canterbury/kaikoura/dem_1m/2193/collection.json
```
