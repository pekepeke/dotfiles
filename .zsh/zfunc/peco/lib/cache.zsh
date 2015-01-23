# (($+functions[_set-cache])) || . ~/.zsh/zfunc/peco/lib/cache.zsh

_set-cache() {
  $@ > $(cache-filename)
}

_cache-filename() {
  echo "/tmp/peco-$$.cache"
}

_remove-cache() {
  rm -f "$(cache-filename)"
}

_print-cache() {
  cat "$(cache-filename)"
}

_peco-zle-print() {
  zle -M "$(echo "$*" | tr "\t" "    ")"
}

_peco-zle-copy() {
  print -n $* | pbcopy-wrapper
  zle -M "copied : $(echo "$*" | tr "\t" "    ")"
}
