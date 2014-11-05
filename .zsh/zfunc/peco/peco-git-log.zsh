peco-git-log() {
  local git_hash=$(git log --oneline | peco --query "$LBUFFER"|cut -d' ' -f1)
  if git rev-parse >/dev/null 2>&1; then
    if [ -n "$git_hash" ]; then
      BUFFER="${BUFFER[1,$pos]}$(echo ${git_hash} | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')${BUFFER[$pos,-1]}"
      CURSOR=$#BUFFER
      zle -R
      # zle -R -c
    fi
  fi
}
zle -N peco-git-log
