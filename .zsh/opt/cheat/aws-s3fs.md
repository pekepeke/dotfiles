## install

```bash
sudo yum -y update
sudo yum -y install gcc-c++ fuse fuse-devel libcurl-devel libxml2-devel  openssl-devel
curl -O http://s3fs.googlecode.com/files/s3fs-1.70.tar.gz
tar xzf s3fs-1.70.tar.gz
cd s3fs-1.70
./configure --prefix=/usr/local
make
sudo make install
find /usr/local -type f
/usr/local/bin/s3fs
/usr/local/share/man/man1/s3fs.1
```

## setup

```bash
echo "bucketname:access_key:secret_access_key" | sudo tee -a /etc/passwd-s3fs
sudo chmod 640 /etc/passwd-s3fs
```

## mount

```
id ec2-user
uid=222(ec2-user) gid=500(ec2-user) 所属グループ=500(ec2-user),10(wheel)

sudo mkdir /share
ls -ld /share
drwxr-xr-x 2 root root 4096 6月 2 01:52 2013 /share

sudo /usr/local/bin/s3fs bucketname /share -o rw,allow_other,use_cache=/tmp,uid=222,gid=500
ls -ld /share

# unmount
sudo fusermount -u /share
```

## fstab

```
s3fs#bucketname /share fuse auto,rw,allow_other,use_cache=/tmp,uid=222,gid=500 0 0
```

