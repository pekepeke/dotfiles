_cd_hist_save_pwd() {
  local cwd="$(pwd -P)"
  local cnt=$(grep "$cwd" ~/.bash_dirs | perl -nle 'print "1" if m!^'"$cwd"'$!;' | wc -l)
  if [ $cnt -eq 0 ]; then
    echo $cwd >> ~/.bash_dirs
  fi
}

_cd_hist_list_dirs() {
  local line
  [ -e ~/.bash_dirs.tmp ] && env rm -f ~/.bash_dirs.tmp
  cat ~/.bash_dirs | while read line; do
    if [ -e "$line" ]; then
      echo "$line"
      echo "$line" >> ~/.bash_dirs.tmp
    fi
  done
  env mv -f ~/.bash_dirs.tmp ~/.bash_dirs
}
