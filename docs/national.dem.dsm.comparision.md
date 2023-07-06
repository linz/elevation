# Other countries DEM/DSM publication

Before making recommendations on how to standardise New Zealands DEM/DSM data LINZ took a brief look at other jurisdictions and how they standardised their DEM and DSM

The key areas to look at were

- compression - What lossless compression was most common
- size (width x height)
- storage type (Tiff/COG/other)

| Country     |             Name             |            Dimensions | File SIze | Type          | Compression      | DataType | Nodata  | CRS        | PixelIsPoint | Comments |
| :---------- | :--------------------------: | --------------------: | --------- | ------------- | ---------------- | -------- | ------- | ---------- | ------------ | -------- |
| New Zealand |  National Elevation 1m DEM   |            480x720 px | 1.4MB     | GeoTiff       | LZW              | Float32  | -9999   | EPSG:2193  | Area/Point   |          |
| Switzerland | swissSURFACE3D Raster (50cm) |           2000x2000px | 16MB      | GeoTiff (COG) | LZW              | Float32  | -9999   | EPSG:2056  | Area         |          |
| USA - USGS  |                              |                       |           |               | LZW (predictor3) | Float32  | -999999 | EPSG:26910 | Area         |          |
| USA - NOAA  |                              |                       |           |               |                  | Float32  | -999999 | EPSG:2229  |              | In Feet  |
| Austraila   |                              | 10000x10000<br>Varies | 4MB       | GeoTiff (COG) | LZW              | Float32  | -9999   | EPSG:7855  |              |          |
| Finland     |                              |                       |           |               |                  | Float32  | -9999   | EPSG:3067  |              |          |
| Canada      |                              |                       |           |               |                  | Float32  | -32767  | EPSG:2958  |              |          |
| Norway      |                              |                       |           |               |                  |          |         |            |              |          |
| France      |                              |                       |           |               |                  |          |         |            |              |          |
| Netherlands |                              |                       |           |               |                  |          |         |            |              |          |
| Scotland    |                              |                       |           |               |                  |          |         |            |              |          |
|             |                              |                       |           |               |                  |          |         |            |              |          |
