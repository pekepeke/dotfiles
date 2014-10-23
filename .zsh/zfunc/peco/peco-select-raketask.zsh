peco-select-raketask-all() {
  local bundle_exec=""
  local rake_option="-T"
  if [ -e Gemfile ]; then
    bundle_exec="bundle exec"
  fi
  local tasks="${bundle_exec} rake ${rake_option}"
  local task="$(eval $tasks | peco )"
  local task_split
  task_split=(${(s/ /)task})

  LBUFFER="${bundle_exec} $task_split[1,2]"
  CURSOR=$#LBUFFER
}
peco-select-raketask() {
  local bundle_exec=""
  local rake_option="-T"
  if [ -e Gemfile ]; then
    bundle_exec="bundle exec"
  fi
  local tasks="${bundle_exec} rake ${rake_option}"
  local task="$(eval $tasks | peco )"
  local task_split
  task_split=(${(s/ /)task})

  LBUFFER="${bundle_exec} $task_split[1,2]"
  CURSOR=$#LBUFFER
}

zle -N peco-select-raketask
zle -N peco-select-raketask-all
