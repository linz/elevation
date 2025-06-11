# Elevation Dataset Naming Conventions

Elevation dataset titles and S3 paths are constructed from metadata about each elevation survey so that they will be consistent and human readable. Elevation is stored according to the majority region that each dataset covers.

## Elevation Dataset Titles

The elevation dataset title is constructed from metadata that is entered when an elevation dataset is processed.

```
<region>[ - <geographic_description>?] [<subtype>?] LiDAR <gsd>m <geospatial_category> (<start_year>[-<end_year>?])[ - <lifecycle>?]
```

which can be broken down as:

- the main `<region>` that the dataset covers
- then if it exists, the `<geographic_description>` is used
- then `<subtype>` if different than the default "Land", for example "Coastal" in the `s3://nz-coastal/` bucket ([`linz/coastal`](https://github.com/linz/coastal))
- then "LiDAR"
- then `<gsd>` (which is always in metres)
- then `<geospatial_category>`
- then `<start_year>` (using all four digits to indicate the year)
- if the elevation dataset was captured over multiple years, include a hyphen and the `<end_year>` (using all four digits to indicate the year)
- if the elevation dataset has been processed as a QC preview or if it only represents partial capture, include "- Preview" or "- Draft" at the end of the title, from the dataset `<lifecycle>`

## Elevation Dataset S3 Paths

The elevation dataset S3 path is also constructed from similar metadata.

```
<region>/
  [<geographic_description>|<region>]_<start_year>[-<end_year>?]/
    <product>_<gsd>m/
      <crs>/
```

which can be broken down as:

- the main `<region>` that the dataset covers
- then if it exists, the `<geographic_description>` is used, if not, `<region>` is repeated instead (this would be the case where the elevation dataset contains full coverage of the region)
- then `<start_year>` (using all four digits to indicate the year)
- if the imagery dataset was captured over multiple years, include a hyphen and the `<end_year>` (using all four digits to indicate the year)
- then `<product>` as multiple products may be created from the same elevation survey
- then `<gsd>` (which is always in metres)
- then `<crs>` as we may store the data in different coordinate reference systems for different purposes

### S3 Path Restrictions

The _path_ is restricted to a limited set of characters with no whitespace: lowercase "a through "z", numbers "0" through "9", hyphen ("-"), and underscore ("\_"). When generating a [dataset S3 path](#imagery-dataset-s3-paths), the system will pass through these characters unchanged to the path, and will transform many others to allowed characters - see the subsections for details. Any characters not mentioned in this section or subsections will result in an error.

#### Uppercase characters

Uppercase characters are changed to lowercase. For example, "Wellington" is changed to "wellington".

#### Diacritics

Characters with [diacritics](https://www.compart.com/en/unicode/block/U+0300), such as macrons ("ā", "ē", etc), are transliterated into Latin script. For example, a dataset with "Ōmāpere" in the title would have "omapere" in the path.

#### Spaces, commas, and slashes

These characters are replaced with a hyphen. For example, "Tikitapu/Blue Lake" is changed to "tikitapu-blue-lake".

#### Apostrophes

These are _removed,_ so "Hawke's Bay" is changed to "hawkes-bay".

#### Ampersands

These are replaced with "-and-", so "Gore A&P Showgrounds" is changed to "gore-a-and-p-showgrounds".

#### Other characters

"ø" is transliterated to "o", so "Mount Brøgger" is changed to "mount-brogger".

## Title and S3 Path Components

### `crs`

EPSG Code for the coordinate reference system of the elevation data. Generally this is [`2193`](https://epsg.io/2193) as it is the primary projection for most of LINZ's elevation data.

### `geographic_description`

This is free text and at the imagery maintainer's discretion. A specific city or sub-region or event name may be used to help describe the elevation data capture area. The [Gazetteer](https://gazetteer.linz.govt.nz/) is referenced to ensure official names with correct spelling are used. If the region has full coverage, then the geographic description can be empty and the region will be used instead.

### `geospatial_category`

A general categorisation of elevation data held within our archive that includes the following possible values:

- DEM `dem`
- DSM `dsm`

### `subtype`

The datasets in the `s3://nz-elevation/` bucket have no specific subtype visible to the data consumer, however they could be referenced as a "Land" subtype. The other subtypes are:

- "Coastal" (`s3://nz-coastal/` - [`linz/coastal`](https://github.com/linz/coastal))

> **_NOTE:_** This is only used for the dataset titles and descriptions for datasets with a subtype different than "Land".

### `gsd`

The GSD or spatial resolution is the area covered on the ground by a single pixel. This is stored in metadata in metres with no trailing zeros after the decimal point.

### `lifecycle`

If `lifecycle = preview` then ` - Preview` is appended to the end of the imagery dataset title and if `lifecycle = ongoing` then ` - Draft` is appended to the end of the imagery dataset title. For any other lifecycle values, nothing is appended.

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
