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
- The extra development time to deal with compressing and decompressing JSON files larger than 128 KB would not offset the savings:
    - We can get the sizes of JSON files by running `aws s3api list-objects-v2 --bucket=nz-elevation --no-sign-request --query="Contents[?ends_with(Key, 'json')].Size"` and `aws s3api list-objects-v2 --bucket=nz-imagery --no-sign-request --query="Contents[?ends_with(Key, 'json')].Size"`
    - Summing up the sizes of files larger than 128 KB we get a total of only _33 MB_ at time of writing
