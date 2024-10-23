# Other Countries DEM/DSM Publication

Before making recommendations on how to standardise New Zealand's DEM/DSM data, LINZ took a brief look at other jurisdictions and how they standardised their DEMs and/or DSMs.

The key areas to look at were
- compression - what lossless compression was most common
- size - width and height of image
- file size - how big each tile is
- storage type (TIFF/COG/other)

| Country     | Name                                                                                                         |       Dimensions (px)   | File SIze | Type          | Compression      | DataType | Nodata  | CRS        | PixelIsPoint | Comments |
| :---------- | :----------------------------------------------------------------------------------------------------------- | :---------------------: | --------- | ------------- | ---------------- | -------- | ------- | ---------- | ------------ | -------- |
| New Zealand | [National Elevation 1m DEM](https://data.linz.govt.nz/group/national-elevation/data/)                        |        480x720          | 1.4MB     | GeoTIFF       | LZW              | Float32  | -9999   | EPSG:2193  | Area/Point   |          |
| Switzerland | [swissSURFACE3D Raster (50cm)](https://www.swisstopo.admin.ch/en/geodata/height/surface3d-raster.html)       |      2,000x2,000        | 16MB      | GeoTIFF (COG) | LZW              | Float32  | -9999   | EPSG:2056  | Area         |          |
| USA - USGS  | [National Map 3DEP](http://prd-tnm.s3.amazonaws.com/index.html?prefix=StagedProducts/Elevation/1m/Projects/) |     10,012x10,012       | 280MB     | GeoTIFF (COG) | LZW (predictor3) | Float32  | -999999 | EPSG:26910 | Area         |          |
| USA - NOAA  | [NOAA Digital Coast LiDAR](https://coast.noaa.gov/dataviewer/#/lidar/search/)                                |      8,463x6,475        | 189NB     | GeoTIFF       | LZW              | Float32  | -999999 | EPSG:2229  |              | In Feet  |
| Australia   | [Victoria 50cm DEM](https://elevation.fsdf.org.au/)                                                          | 10,000x10,000<br>Varies | 4MB       | GeoTIFF (COG) | LZW              | Float32  | -9999   | EPSG:7855  |              |          |
| Finland     | [2M DEM](https://asiointi.maanmittauslaitos.fi/karttapaikka/tilausvahvistus)                                 |       3,000x3,000       | 20MB      | GeoTIFF       | LZW              | Float32  | -9999   | EPSG:3067  |              |          |
| Canada      | [HRDEM - CanElevation Series](https://open.canada.ca/data/en/dataset/957782bf-847c-4644-a757-e383c0057995)   |      10,000x10,000      |           | GeoTIFF       | LZW              | Float32  | -32767  | EPSG:2958  |              |          |
| Norway      | [Norway DTM1](https://hoydedata.no/LaserInnsyn2/)                                                            |      15,010x15,010      |           | GeoTIFF       | LZW              |          |         |            |              |          |
| France      | [RGE ALTI 1m](https://geoservices.ign.fr/rgealti)                                                            |       1,000x1,000       |           | Ascii Grid    |                  |          |         |            |              |          |
| Netherlands | [Actueel Hoogtebestand Nederland AHN3](https://app.pdok.nl/rws/ahn3/download-page/)                          |      10,000x12,500      |           | GeoTIFF       | RAW (Zipped)     |          | 3.4e+38 | EPSG:28992 |              |          |
| Scotland    | [LiDAR for Scotland DTM](https://remotesensingdata.gov.scot/data#/list)                                      |      10,000x6,000       | 132MB     | GeoTIFF       | LZW              |          | -9999   | EPSG:27700 | Area         |          |
|             |                                                                                                              |                         |           |               |                  |          |         |            |              |          |

This table was recorded in May 2023 and may now be out-of-date.
