google_translate() { #{{{2
  local str opt cond

  if [ $# != 0 ]; then
    str=`echo $1 | sed -e 's/  */+/g'` # 1文字以上の半角空白を+に変換
    cond=$2
    if [ $cond = "ja-en" ]; then # ja -> en 翻訳
      opt='?hl=ja&sl=ja&tl=en&ie=UTF-8&oe=UTF-8'
    else # en -> ja 翻訳
      opt='?hl=ja&sl=en&tl=ja&ie=UTF-8&oe=UTF-8'
    fi
  else
    opt='?hl=ja&sl=en&tl=ja&ie=UTF-8&oe=UTF-8'
  fi

  opt="${opt}&text=${str}"
  w3m +13 "http://translate.google.com/${opt}"
}

# cakec functions {{{1
cakec_find_approot() { #{{{2
  local cwd=$(pwd)
  local appdir=$cwd/app
  while [ 1 ] ; do
    [ -e $appdir/Console/cake ] && break
    [ -e $appdir/../cake/console/cake ] && break
    if [ -e $appdir/app/cake/console/cake ] ; then
      appdir=$appdir/app
      break
    fi
    [ -e $appdir/console/cake ] && break
    if [ "/" = "$appdir" ] ; then
      echo "directory not found"
      return 1
    fi
    if [ -e $appdir/cakephp/app/console/cake ]; then
      appdir=$appdir/cakephp/app
      break
    fi
    if [ -e $appdir/cakephp/app/Console/cake ]; then
      appdir=$appdir/cakephp/app
      break
    fi
    appdir=$(dirname $appdir)
  done
  echo $appdir
}

cakec_find_tmpdir() { #{{{2
  local cwd=$(pwd)
  local tmpdir=$cwd
  [ -e $tmpdir/app ] && tmpdir=$tmpdir/app
  while [ 1 ] ; do
    [ -e $tmpdir/tmp ] && break
    if [ "/" = "$tmpdir" ] ; then
      echo "directory not found"
      return 1
    fi
    tmpdir=$(dirname $tmpdir)
  done
  echo $tmpdir/tmp
}


cake-dispatch() { #{{{2
  local mode=$1 rlwrap=$(which rlwrap 2>/dev/null)
  local cwd=$(pwd)
  shift

  [ x$ENV = x ] && ENV=development
  [ x$CAKE_ENV = x ] && CAKE_ENV=development
  case $mode in
    console)
      local appdir=$(cakec_find_approot)
      if [ -x "$appdir/Console/cake" ] ; then
        (cd "$appdir"; ENV=$ENV CAKE_ENV=$CAKE_ENV $rlwrap Console/cake $*)
      elif [ -x "$appdir/console/cake" ]; then
        (cd "$appdir"; ENV=$ENV CAKE_ENV=$CAKE_ENV $rlwrap console/cake $*)
      elif [ -e "$appdir/../cake/console/cake" ]; then
        (cd "$appdir"; ENV=$ENV CAKE_ENV=$CAKE_ENV $rlwrap sh $appdir/../cake/console/cake $*)
      else
        echo "command not found $*"
      fi
      ;;
    clear-cache)
      local tmpdir=$(cakec_find_tmpdir)
      echo "remove cache : $tmpdir/cache"
      (cd "$tmpdir"; [ -e ./cache ] && find ./cache -type f -name 'cake_*' -exec rm -f {} \; && find ./cache/views -type f ! -name '.*' -exec rm -f {} \;)
      ;;
    *)
      echo "command not found $*"
      ;;
  esac
}

# {{{1
