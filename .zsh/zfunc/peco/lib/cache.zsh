set-cache() {
  $@ > $(cache-filename)
}

cache-filename() {
  echo "/tmp/peco-$$.cache"
}

remove-cache() {
  rm -f "$(cache-filename)"
}

print-cache() {
  cat "$(cache-filename)"
}

peco-zle-print() {
  zle -M "$(echo "$*" | tr "\t" "    ")"
}

peco-zle-copy() {
  print -n $* | pbcopy-wrapper
  zle -M "copied : $(echo "$*" | tr "\t" "    ")"
}
