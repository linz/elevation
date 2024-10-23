# Area or Point

## TLDR

Toitū Te Whenua (LINZ) has decided to standardise all of it's DEM/DSM GeoTIFFs into `PixelIsArea`

## Background

GeoTIFF files have a TIFF tag `GTRasterTypeGeoKey` that controls how to interpret pixels inside of the GeoTIFF.

- `Pixel Is Point` the value of the pixel represent the point in the center of the pixel
- `Pixel Is Area` the value of the pixel represents the full area of the pixel for a 1m resolution it is 1m x 1m

When a GeoTIFF is `Pixel Is Point` the TIFF's origin point is shifted by half a pixel, as the origin of the pixel is the center of the pixel.

LINZ Elevation DEM and DSM's previously contained a mixture of `Point` and `Area`.

From a [brief survey of other jurisdictions](./national-dem-dsm/README.md.md) they mostly all use `Area`.

Area is also consistent with how [LINZ's Aerial Imagery](https://github.com/linz/imagery) is stored.

## References

- GDAL RFC: https://trac.osgeo.org/gdal/wiki/rfc33_gtiff_pixelispoint
- https://www.usna.edu/Users/oceano/pguth/md_help/html/PixelIsWhat.html
