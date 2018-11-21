#!/bin/bash

root="$(cd $(dirname $0); pwd)"
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

update_complation() {
  cd $root/completion/
  # curl -Lo _git "http://sourceforge.net/p/zsh/code/ci/master/tree/Completion/Unix/Command/_git?format=raw"
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
  curl -Lo _docker-compose https://raw.githubusercontent.com/sdurrheimer/docker-compose-zsh-completion/master/_docker-compose

  curl -Lo _docker https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
  curl -Lo tig-completion.bash https://raw.githubusercontent.com/jonas/tig/master/contrib/tig-completion.bash
  curl -Lo _tig https://raw.githubusercontent.com/jonas/tig/master/contrib/tig-completion.zsh
  for f in "" -doc -galaxy -playbook -pull -vault; do
    curl -Lo _ansible${f} https://raw.githubusercontent.com/jdottdot/ansible-zsh-completion/master/_ansible${f}
  done
  curl -LO https://raw.githubusercontent.com/pocke/ptmux/master/zsh_completions/_ptmux
  curl -Lo _tmass https://raw.githubusercontent.com/fzerorubigd/tmass/master/tools/zsh_tmass
  curl -Lo _kubectx https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubectx.zsh
  curl -Lo _kubens https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/kubens.zsh
}

update_compfunc() {
  cd $root/compfunc
  # curl -Lo git-flow-completion.zsh https://raw.githubusercontent.com/bobthecow/git-flow-completion/master/git-flow-completion.zsh
}


main() {
  local cwd=$(pwd)

  update_complation

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

