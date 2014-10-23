peco-git-log() {
  local git_hash=$(git log --oneline | peco --query "$LBUFFER"|cut -d' ' -f1)
  if git rev-parse >/dev/null 2>&1; then
    if [ -n "$git_hash" ]; then
      LBUFFER="git ${git_hash}"
      CURSOR=4
    fi
  fi
}
zle -N peco-git-log
