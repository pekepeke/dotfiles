peco-select-raketask-all() {
  local bundle_exec=""
  local rake_option="-T"
  if [ -e Gemfile ]; then
    bundle_exec="bundle exec"
  fi
  local tasks="${bundle_exec} rake ${rake_option}"
  local task="$(eval $tasks | peco | awk '{print $1}')"

  if [ -n "$task" ]; then
    LBUFFER="${bundle_exec} $(echo $task | tr "[:cntrl:]" " ")"
    CURSOR=$#LBUFFER
  fi
}
peco-select-raketask() {
  local bundle_exec=""
  local rake_option="-T"
  if [ -e Gemfile ]; then
    bundle_exec="bundle exec"
  fi
  local tasks="${bundle_exec} rake ${rake_option}"
  local task="$(eval $tasks | peco | awk '{print $1}')"

  if [ -n "$task" ]; then
    LBUFFER="${bundle_exec} $(echo $task | tr "[:cntrl:]" " ")"
    CURSOR=$#LBUFFER
  fi
}

zle -N peco-select-raketask
zle -N peco-select-raketask-all
