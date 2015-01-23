# (($+functions[_find-files-with-peco])) || . ~/.zsh/zfunc/peco/lib/find.zsh

_get-find-option() {
  case "$1" in
    ag|ack|ack-grep)
       echo ' --noheading --nocolor --nogroup --nopager -g "" '"$2"
      ;;
    find)
      # echo "$2"' -type f | grep -v ".git"'
      echo "$2"' -type f'
      ;;
    files)
      echo "-a=true \"$2\""
      ;;
    *)
      echo "$2"
  esac
}

_find-files-with-peco() {
  local DIR="$1"
  local query="$2"
  if [ x"${DIR}" = x -o ! -e "${DIR}" ]; then
    echo "directory not found : ${DIR}" 1>&2
    return 1
  fi
  if [ -L "$DIR" ]; then
    DIR="$(python -c 'import os,sys;print os.path.realpath(sys.argv[1])' "$DIR")"
  fi

  local find_bin
  # slow : ack-grep
  for find_bin in files ag find; do
  # for findbin in find; do
    if type $find_bin >/dev/null 2>&1; then
      break
    fi
  done

  if [ x"${find_bin}" = x ]; then
    echo "directory scanner command not found" 1>&2
    return 11
  fi

  local find_option="$(_get-find-option $find_bin $DIR)"

  if [ -z "$query" ]; then
    eval $find_bin $find_option | peco
  else
    eval $find_bin $find_option | peco --query="$query"
  fi
}
