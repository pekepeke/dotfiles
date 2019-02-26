#!/bin/bash

executable() {
  which > /dev/null 2>&1
}

get_ostype() {
  case $OSTYPE in
    cygwin*)
      echo cygwin
      ;;
    solaris*)
      echo "solaris"
      ;;
    darwin*)
      echo "osx"
      ;;
    linux*)
      echo "linux"
      ;;
    bsd*)
      echo "bsd"
      ;;
  esac
  return 0
}

cat_file() {
  cat $1 | perl -ne 's/\s*#.*$//g; print;'
}

get_distribution() {
  # TODO : detect distribution
  if [ -e /etc/lsb-release ]; then
    . /etc/lsb-release
    echo $(echo $DISTRIB_ID | tr '[:upper:]' '[:lower]')
  elif [ -e /etc/readhat-release ]; then
    echo redhat
  fi
}


is_win() {
  case $OSTYPE in
    cygwin*)
      return 0;;
  esac
  return 1
}

is_mac() {
  case $OSTYPE in
    darwin*)
      return 0;;
  esac
  return 1
}

has_package() {
  if is_win ; then
    return
  fi
  if is_mac ;then
    brew list $1 >/dev/null 2>&1
    return $?
  else
    if executable yum ; then
      return $?
    elif executable apt-get ; then
      return $?
    fi
    #
    return
  fi
  return 1
}

libraries_from_file() {
  if [ x"$1" = x -o ! -f "$1" ]; then
    # echo "file not found : $1"
    return 1
  fi
  cat_file $1
}

install_command_find() {
  if [ x"$1" = x ]; then
    echo "command not found: $1" >&2
    return 1
  fi
  if ! which $1 >/dev/null 2>&1; then
    echo "command not found: $1" >&2
    return 1
  fi

  case "$1" in
    npm)
      echo $1 -g install
      ;;
    pyrus)
      echo $1
      ;;
    composer)
      echo $1 global require
      ;;
    go)
      echo $1 get -u
      ;;
    brew|pip|pip3|gem|apm)
      echo $1 install
      ;;
    apt-get)
      echo sudo $1 install
      ;;
    *)
      echo $1
      ;;
  esac
}

install_type_find() {
  case $1 in
    brew|pyrus|go|composer)
      echo each
      ;;
  esac
}

install_by() {
  warn_if_system $1
  local base_cmd=$1
  shift
  local install_cmd=$(install_command_find $base_cmd)
  if [ x"$install_cmd" = x ]; then
    echo "command not found : $base_cmd" 1>&2
    return 1
  fi
  # local install_type=$(install_type_find $base_cmd)
  local is_installed=0

  local cwd=$(pwd)
  local scriptdir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"

  local ostype=$(get_ostype)
  local source_path
  cd "$scriptdir"
  for source_path in "source/$base_cmd.txt" "source/${base_cmd}_${ostype}.txt"; do
    if [ ! -e $source_path ]; then
      continue
    fi
    is_installed=1
    # if [ x"${install_type}" = x"each" ]; then
      (
      IFS=$'\t\n';
      local packages=$(libraries_from_file "$source_path")
      for f in $packages; do
        IFS=$' \t\n'
        echo $install_cmd $f "$@"
        $install_cmd $f "$@"
        IFS=$'\t\n';
      done
      )
    # else
    #   local packages=$(libraries_from_file "$source_path")
    #   echo $install_cmd $packages "$@"
    #   $install_cmd $packages "$@"
    # fi
  done
  for script_path in "source/${base_cmd}_install.sh" "source/${base_cmd}_${ostype}_install.sh"; do
    if [ -x $script_path ]; then
      echo "execute : $script_path"
      eval $script_path
    fi
  done
  cd "$cwd"
  if [ $is_installed -eq 0 ]; then
    echo "package not found : $1" 1>&2
    return 2
  else
    for script_path in "source/${base_cmd}_after.sh" "source/${base_cmd}_${ostype}_after.sh"; do
      if [ -x $script_path ]; then
        echo "execute : $script_path"
        eval $script_path
      fi
    done
  fi
}

warn_if_system() {
  local xpath=$(which $1 >/dev/null 2>&1)
  local res
  if [ x"$xpath" = x ]; then
    return 1
  fi
  if [ $xpath =~ "env/shims/" ]; then
    # get xxenv path
    local llenv=$(echo $xpath | perl -ne 'm!/\.(.*)/shims!; print $1;')
    xpath=$(llenv prefix)/bin/$1
  fi
  if [ $xpath =~ "^/usr/bin" -o $xpath =~ "^/usr/local/bin" ]; then
    echo "You are trying to install using the system $1($xpath). continue ok? [y/n]"
    read res
    if [ x"$res" != x"y" ]; then
      echo abort 1>&2
      exit 1
    fi
  fi
}

install_env() {
  local cwd=$(pwd)
  # local scriptdir=$(cd $(dirname $0); pwd)
  local scriptdir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
  local definedir="$scriptdir/env"

  local llenv=$1
  shift

  local repo_url=$(cat_file $definedir/env/${llenv}.txt 2>/dev/null)
  local plugin_urls=$(cat_file $definedir/plugin/${llenv}.txt 2>/dev/null)
  local before_cmd=""
  local install_cmd=""
  local upgrade_cmd=""
  [ -e $definedir/env/${llenv}_before.sh ] && before_cmd="bash $definedir/env/${llenv}_before.sh"
  [ -e $definedir/env/${llenv}_install.sh ] && install_cmd="bash $definedir/env/${llenv}_install.sh"
  [ -e $definedir/env/${llenv}_upgrade.sh ] && upgrade_cmd="bash $definedir/env/${llenv}_upgrade.sh"

  local after_cmd=""
  # local pre_cmd=""
  [ -e $definedir/env/${llenv}_after.sh ] && after_cmd="bash $definedir/env/${llenv}_after.sh"
  # [ -e $definedir/env/${llenv}_pre.sh ] && pre_cmd="bash $definedir/env/${llenv}_pre.sh"


  local noeval=$(test x"$repo_url" = x && echo 1 || echo 0)

  if [ x"$llenv" = x ]; then
    echo "illegal arguments." 1>&2
    return 1
  fi
  # echo $repo_url
  if [ x"$repo_url" = x -a x"$install_cmd" = x ]; then
    echo "installer not found : $llenv" 1>&2
    return 2
  fi

  # local repo_url=$1
  # local llenv=$(basename $repo_url .git)
  local root_dir="$HOME/.${llenv}"
  local libexec_dir="${root_dir}/libexec"
  local repo reponame

  # echo $root_dir
  # echo $repo_url
  # echo $plugin_urls
  # echo $llenv
  # echo $install_cmd
  # echo $upgrade_cmd

  if [ -e $root_dir ]; then
    if [ x"$before_cmd" ]; then
      cd $root_dir
      eval $before_cmd
    fi
    if [ x"$upgrade_cmd" != x ]; then
      cd $root_dir
      echo "run : $upgrade_cmd"
      eval $upgrade_cmd
    else
      cd $root_dir && git pull
    fi
  else
    if [ x"$install_cmd" != x ]; then
      echo "run : $install_cmd"
      eval "$install_cmd"
    else
      git clone $repo_url $root_dir
    fi
  fi

  [ ! -e $root_dir/plugins ] && mkdir -p $root_dir/plugins
  cd $root_dir/plugins

  for repo in $plugin_urls; do
    reponame=$(basename $repo .git)
    if [ -e $reponame ]; then
      cd $reponame
      git pull
      cd ..
    else
      git clone $repo
    fi
  done

  shift
  for repo in "$*" ; do
    if [ x"$repo" = x ]; then
      continue
    fi
    local reponame=$(basename $repo .git)
    if [ -e $reponame ]; then
      cd $reponame
      git pull
      cd ..
    else
      git clone $repo
    fi
  done

  local f
  local name
  cd "$scriptdir"
  if [ -e env/libexec/${llenv} ]; then
    for f in $(ls env/libexec/${llenv}/*); do
      name=$(basename $f)
      if [ ! -e "$libexec_dir/$name" ]; then
        [ ! -e "$libexec_dir" ] && mkdir "$libexec_dir"
        cp "$f" "$libexec_dir/$name"
        chmod +x "$libexec_dir/$name"
      fi
    done
  fi

  if [ -e ${root_dir}/completions/ ]; then
    for f in $(ls ${root_dir}/completions/); do
      local source_file=${root_dir}/completions/$f
      local dest_file=$(echo $source_file | sed -e 's/rbenv/${llenv}/')
      if [ ! -e $dest_f ];then
        cp $source_file $dest_file
        perl -i -pe 's|rbenv|${llenv}|g' $dest_file
      fi
    done
  fi

  cd "${root_dir}"
  if [ x"$after_cmd" != x ]; then
    echo "Running : $after_cmd"
    $after_cmd
  fi
  cd "$scriptdir"

  cd $cwd

  export PATH="${root_dir}/bin:$PATH"
  [ x"$noeval" = x0  ] && eval "$($llenv init -)"

  echo "install finished : $llenv"
}

show_libs() {
  local cwd=$(pwd)
  # local scriptdir=$(cd $(dirname $0); pwd)
  local scriptdir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
  local os=$(get_ostype)

  local f
  for f in $(ls $scriptdir/source/*.txt 2>/dev/null); do
    if [[ "$f" =~ _(ubuntu|osx)\..*$ ]]; then
      continue
    fi
    echo $(basename $f .txt)
  done
}

show_packages() {
  local cwd=$(pwd)
  # local scriptdir=$(cd $(dirname $0); pwd)
  local scriptdir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
  local os=$(get_ostype)

  local f
  for f in $(ls $scriptdir/source/packages/*.sh 2>/dev/null); do
    echo $(basename $f .sh)
  done

  for f in $(ls $scriptdir/source/packages/$os/*.sh 2>/dev/null); do
    echo $(basename $f .sh)
  done

  cd $cwd
}

install_package() {

  local cwd=$(pwd)
  # local scriptdir=$(cd $(dirname $0); pwd)
  local scriptdir="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
  local os=$(get_ostype)
  local distribution=$(get_distribution)

  local f scrptfpath
  f=$1
  shift

  scriptfpath="$scriptdir/source/packages/$os/$distribution/${f}.sh"
  # echo $scriptfpath

  [ ! -e $scriptfpath ] && scriptfpath="$scriptdir/source/packages/$os/${f}.sh"
  [ ! -e $scriptfpath ] && scriptfpath="$scriptdir/source/packages/${f}.sh"
  if [ ! -e $scriptfpath ]; then
    echo "package not found : $f [$scriptfpath]" 1>&2
    return 1
  fi
  $scriptfpath "$@"

  cd $cwd
}

