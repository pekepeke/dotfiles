#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  local cwd=$(pwd)
  cd $(dirname $0)/completion/

  curl -Lo git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
  curl -Lo _git https://raw.github.com/git/git/master/contrib/completion/git-completion.zsh
  curl -Lo _git-issue https://raw.githubusercontent.com/glidenote/git-issue-zsh-completion/master/_git-issue
  curl -Lo _padrino https://raw.github.com/matthias-guenther/padrino-zsh-completion/master/_padrino
  curl -Lo _loga https://raw.github.com/tacahiroy/loga-zsh-completion/master/_loga_zsh_completion.zsh
  curl -Lo _hub https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion
  curl -Lo _knife https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/plugins/knife/_knife
  curl -Lo _pebble https://raw.githubusercontent.com/Neal/pebble-zsh-completion/master/_pebble
  curl -Lo _grunt https://raw.githubusercontent.com/yonchu/grunt-zsh-completion/master/_grunt
  curl -Lo _pip https://raw.githubusercontent.com/dgladkov/zsh-pip-completion/master/_pip
  curl -Lo _curl https://raw.githubusercontent.com/Valodim/zsh-curl-completion/master/_curl
  curl -Lo _packer https://raw.githubusercontent.com/gunzy83/packer-zsh-completion/master/_packer
  curl -Lo _puppet https://raw.githubusercontent.com/dkudrow/puppet-completion-zsh/master/_puppet
  curl -Lo _dropbox https://raw.githubusercontent.com/ivoarch/dropbox-zsh-completion/master/_dropbox

  curl -Lo _gcloud https://raw.githubusercontent.com/littleq0903/gcloud-zsh-completion/master/src/_gcloud
  curl -Lo _appcfg.py https://raw.githubusercontent.com/littleq0903/gcloud-zsh-completion/master/src/_appcfg.py
  cd $cwd
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

