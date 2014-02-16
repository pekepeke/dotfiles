#!/bin/bash

FILE=~/.my.cnf

if [ -e "$FILE" ]; then
  echo "already exists: $FILE" 1>&2
  exit 1
fi

echo "Mysql User > "
read USER
echo "Mysql Password > "
read PASSWORD

if [ x"$USER" = x -o x"$PASSWORD" = x ]; then
  echo "USER or PASSWORD is must be specified." 1>&2
  exit 1
fi

cat <<EOM > $FILE
[client]
user="$USER"
password="$PASSWORD"

[mysql]
no-auto-rehash

[mysqlhotcopy]
interactive-timeout
EOM


