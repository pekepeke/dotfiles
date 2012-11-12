function zaw-src-keepass() {
  local IFS=$'\n'
  candidates=(`keepass`)
  actions=(zaw-keepass-exec zaw-keepass-verbose)
  act_descriptions=("copy password" "show verbose")
}

zaw-keepass-id() {
  echo $1|cut -d'|' -f1
}

zaw-keepass-exec() {
  BUFFER="keepass -n $(zaw-keepass-id $1)"
  zle accept-line
}

zaw-keepass-verbose() {
  BUFFER="keepass -v -n $(zaw-keepass-id $1)"
  zle accept-line
}

zaw-register-src -n keepass zaw-src-keepass
