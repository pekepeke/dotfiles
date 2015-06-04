#!/bin/bash

if [ -e test ]; then
  echo "already inventory file: test" >&2
  exit 1
fi

cat <<EOM > test
[web-servers]
www1.example.com
www2.example.com

[db-servers]
db1.example.com

[test:children]
web-servers
db-servers
EOM

MAIN_YAMLS="roles/common/tasks roles/common/handlers roles/comon/vars roles/common/defaults/ roles/common/meta"
for d in group_vars host_vars library filter_plugins \
  roles/common/templates roles/common/files ${MAIN_YAMLS} ; do
  mkdir -p ${d}
done

for d in ${MAIN_YAMLS} ; do
  touch ${d}/main.yml
done

touch group_vars/test.yml

