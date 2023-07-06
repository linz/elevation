# Area or Point

## TLDR

Toitū Te Whenua (LINZ) has decided to standardise all of it's DEM/DSM into `PixelIsArea`

## Background

Geotiff files have a tiff tag `GTRasterTypeGeoKey` that controls how to interpret pixels inside of the tiff

- `Pixel Is Point` the value of the pixel represent the point in the center of the pixel
- `Pixel Is Area` the value of the pixel represents the full area of the pixel for a 1m resolution it is 1m x 1m

When a geotiff is `Pixel Is Point` the tiff's origin point is shifted by half a pixel, as the origin of the pixel is the center of the pixel.

LINZ elevation DEM and DSM's current contain a mixture of `Point` and `Area`

From a [brief survey of other jurisdictions](./national-dem-dsm/README.md.md) they mostly all use `Area`,

Area is also consistent with how [LINZ's aerial imagery](https://github.com/linz/imagery) is stored.

## References

- GDAL RFC: https://trac.osgeo.org/gdal/wiki/rfc33_gtiff_pixelispoint
- https://www.usna.edu/Users/oceano/pguth/md_help/html/PixelIsWhat.html
