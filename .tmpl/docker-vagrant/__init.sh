#1/bin/bash

git clone https://github.com/dotcloud/docker.git
cd docker

cat <<EOM
## run vm

vagrant up --provider=virtualbox
EOM

