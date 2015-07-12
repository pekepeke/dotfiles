#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  ### vagrant-aws(create aws ec2)
  vagrant plugin install vagrant-aws

  vagrant plugin install sahara
  vagrant plugin install vagrant-cachier ### vagrant-cachier(provision高速化)
  vagrant plugin install vagrant-vbox-snapshot
  vagrant plugin install vagrant-vbguest ### vagrant-vbguest(Virtualbox-guest-addtion自動インストール)
  vagrant plugin install vagrant-omnibus ### vagrant-omnibus(chef自動インストール)

  vagrant plugin install vagrant-proxyconf
  # vagrant plugin install vagrant-global-status ### vagrant-global-status(VMの一覧表示)
  # vagrant plugin install vagrant-berkshelf ### berkshelf
  vagrant plugin install vagrant-hostmanager ### vagrant-hostmanager(/etc/hosts)

  # https://github.com/garethr/ruby-vagrantboxes.git
  # https://github.com/jedi4ever/veewee.git
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvs:" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
    s)
      #$OPTARG
      ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

