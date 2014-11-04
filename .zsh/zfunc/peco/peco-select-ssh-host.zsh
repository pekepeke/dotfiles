peco-select-ssh-host() {
  local host=$(cat ~/.ssh/config | awk '$1 == "Host" { print $2 }' | peco --query="$LBUFFER")
  if [ -n "${host}" ];then
    LBUFFER="ssh $host"
    CURSOR=$#LBUFFER
  fi
  zle -R -c
}
zle -N peco-select-ssh-host
