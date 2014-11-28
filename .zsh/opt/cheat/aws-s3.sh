# ls
aws s3 ls s3://bucket
# make backet
aws s3 mb s3://bucket --region us-west-1
# remove backet
aws s3 rb s3://bucket
aws s3 rb s3://bucket -- force

aws s3 cp a.txt s3://mybucket --exclude=".DS_Store" --acl=public-read
aws s3 cp dir s3://mybucket/path --recursive --exclude=".DS_Store" --acl=public-read

aws s3 rm s3://bucket/path/to/file
aws s3 rm s3://bucket/path/to/ --recursive
aws s3 rm s3://bucket/path/to/ --recursive --exclude="*.jpg"
aws s3 rm s3://mybucket/ --recursive --exclude="mybucket/another/*"

aws s3 sync . s3://mybucket --exclude=".DS_Store" --acl=public-read
aws s3 sync . s3://mybucket --exclude=".DS_Store" --acl=public-read --delete

