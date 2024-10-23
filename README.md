# New Zealand Elevation

Toitū Te Whenua makes New Zealand's most up-to-date publicly owned elevation data freely available to use under an open licence. You can access this through the [LINZ Data Service](https://data.linz.govt.nz/data/category/elevation/), [LINZ Basemaps](https://basemaps.linz.govt.nz/@-41.8899962,174.0492437,z5?i=elevation) or the [Registry of Open Data on AWS](https://registry.opendata.aws/nz-elevation/).

This repository contains STAC Collection metadata for each elevation dataset, as well as some guidance documentation:

- [Naming](docs/naming.md) covers the s3://nz-elevation bucket naming structure
- [Usage](docs/usage.md) shows how TIFFs can be interacted with from S3 using GDAL, QGIS, etc
- [Elevation Compression](docs/tiff-compression) provides commentary and analysis on the compression options we explored.

## AWS Access

Toitū Te Whenua owns and maintains a public bucket which is sponsored and shared via the [Registry of Open Data on AWS](https://registry.opendata.aws/nz-elevation/) `s3://nz-elevation` in `ap-southeast-2`.

Using the [AWS CLI](https://aws.amazon.com/cli/) anyone can access all of the imagery specified in this repository.

```
aws s3 ls --no-sign-request s3://nz-elevation/
```

### Browsing the S3 Bucket

[STAC Browser](https://radiantearth.github.io/stac-browser/#/external/nz-elevation.s3.ap-southeast-2.amazonaws.com/catalog.json) can be used to browse through the contents of the S3 bucket.

## Related

For access to LINZ's aerial and satellite imagery see [linz/imagery](https://github.com/linz/imagery)

## License

Source code is licensed under [MIT](LICENSE).

All metadata and docs are licensed under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/).

For [more information on elevation attribution](https://www.linz.govt.nz/products-services/data/licensing-and-using-data/attributing-elevation-or-aerial-imagery-data).
