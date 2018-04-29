defmodule HTTPMock do
  def request(:get, {'https://s3.amazonaws.com/ssst-test', []}, [], []) do
    {:ok,
      {{'HTTP/1.1', 200, 'OK'},
        [
          {'date', 'Sun, 29 Apr 2018 19:16:30 GMT'},
          {'server', 'AmazonS3'},
          {'content-length', '436'},
          {'content-type', 'application/xml'},
          {'x-amz-id-2',
            'jXn6YVB0chkI4S5O02StiTDH+sQ2HO60KqM3nmZkrvEAZOcquSZpyE+BIg0Eh0/k4aB41z34f44='},
          {'x-amz-request-id', 'D6C70AD46954332C'},
          {'x-amz-bucket-region', 'us-east-1'}
        ],
        '<?xml version="1.0" encoding="UTF-8"?>\n<ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Name>ssst-test</Name><Prefix></Prefix><Marker></Marker><MaxKeys>1000</MaxKeys><IsTruncated>false</IsTruncated><Contents><Key>ssst.txt</Key><LastModified>2018-04-29T09:12:40.000Z</LastModified><ETag>&quot;4212059ccb907291311f28f8168d0b29&quot;</ETag><Size>5</Size><StorageClass>STANDARD</StorageClass></Contents></ListBucketResult>'}}
  end
end
