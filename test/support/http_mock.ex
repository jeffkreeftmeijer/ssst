defmodule HTTPMock do
  def request(:get, {'https://s3.amazonaws.com/ssst-test', []}, [], []) do
    {:ok,
     {{'HTTP/1.1', 200, 'OK'},
      [
        {'date', 'Sun, 29 Apr 2018 20:51:48 GMT'},
        {'server', 'AmazonS3'},
        {'content-length', '696'},
        {'content-type', 'application/xml'},
        {'x-amz-id-2',
         '1S2/3XwXJM/D+7jq2R7HTn1u851zwtIT/tFSWd7ipMOf01KENT0pyOE73Y4ZNF/c/lSqe6klc/E='},
        {'x-amz-request-id', '019963A36918DF05'},
        {'x-amz-bucket-region', 'us-east-1'}
      ],
      '<?xml version="1.0" encoding="UTF-8"?>\n<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Name>ssst-test</Name><Prefix></Prefix><Marker></Marker><MaxKeys>1000</MaxKeys><IsTruncated>false</IsTruncated><Contents><Key>private.txt</Key><LastModified>2018-04-29T19:43:04.000Z</LastModified><ETag>&quot;be2a401b3cab43750487fc4341ee628f&quot;</ETag><Size>4</Size><Owner><ID>65a011a29cdf8ec533ec3d1ccaae921c</ID></Owner><StorageClass>STANDARD</StorageClass></Contents><Contents><Key>ssst.txt</Key><LastModified>2018-04-29T09:12:40.000Z</LastModified><ETag>&quot;4212059ccb907291311f28f8168d0b29&quot;</ETag><Size>5</Size><StorageClass>STANDARD</StorageClass></Contents></ListBucketResult>'}}
  end

  def request(:get, {'https://s3.amazonaws.com/ssst-test/ssst.txt', []}, [], []) do
    {:ok,
     {{'HTTP/1.1', 200, 'OK'},
      [
        {'date', 'Sun, 29 Apr 2018 21:46:54 GMT'},
        {'accept-ranges', 'bytes'},
        {'etag', '"4212059ccb907291311f28f8168d0b29"'},
        {'server', 'AmazonS3'},
        {'content-length', '5'},
        {'content-type', 'text/plain'},
        {'last-modified', 'Sun, 29 Apr 2018 09:12:40 GMT'},
        {'x-amz-id-2',
         'PwmxsaeKxEtm4OUXDSM5tWRZwf4evdMrniTaxOU/wqimxW3LUPdsX/Lg0FZYiDOGcgAicGsDl9g='},
        {'x-amz-request-id', '2EF978AD6FC8A8BD'}
      ], 'ssst\n'}}
  end
end
