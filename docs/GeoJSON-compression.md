# GeoJSON compression

## Summary

Toitū Te Whenua has decided to store all metadata _uncompressed,_ including GeoJSON.

## Arguments

Pro compression:

- Saves money on storage
- Saves time and money on transfer of data
- Metadata files are highly compressible, since they have a lot of text strings and repetition

Contra compression:

- Some tools do not seamlessly decompress files
  - [AWS CLI issue](https://github.com/aws/aws-cli/issues/6765)
  - [boto3 issue](https://github.com/boto/botocore/issues/1255)
- Any files on S3 "[smaller than 128 KB](https://aws.amazon.com/s3/pricing/)" (presumably actually 128 KiB) are treated as being 128 KB for pricing purposes, so there would be no price gain from compressing any files which are smaller than this
- The extra development time to deal with compressing and decompressing would probably not offset the savings
