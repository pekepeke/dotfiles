peco-select-ssh-host() {
  local host=$(cat ~/.ssh/config | awk '$1 == "Host" { print $2 }' | peco --query="$LBUFFER")
  LBUFFER="ssh $host"
  CURSOR=$#LBUFFER
}
zle -N peco-select-ssh-host
