# GeoJSON compression

## Summary

Toitū Te Whenua has decided to store all metadata _uncompressed,_ including GeoJSON.

## Arguments

Pro compression:

- Saves money on storage
- Saves time and money on transfer of data

Contra compression:

- Some tools do not seamlessly decompress files
  - [AWS CLI issue](https://github.com/aws/aws-cli/issues/6765)
  - [boto3 issue](https://github.com/boto/botocore/issues/1255)
