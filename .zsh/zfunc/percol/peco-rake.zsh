rakep() {
  local bundle_exec=""
  local rake_option="-T"
  if [ -e Gemfile ]; then
    bundle_exec="bundle exec"
  fi
  if [ "$1" = "-a" -o "$1" = "-A" ]; then
    rake_option="-AT"
  fi
  local tasks="${bundle_exec} rake ${rake_option}"
  local task="$(eval $tasks | peco )"
  local task_split
  task_split=(${(s/ /)task})

  print -z "${bundle_exec} $task_split[1,2]"
}

