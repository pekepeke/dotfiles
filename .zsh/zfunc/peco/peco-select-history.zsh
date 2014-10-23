function peco-select-history() {
  local tac_cmd
  which gtac &> /dev/null && tac_cmd=gtac || tac_cmd=tac
  local selected="$($tac_cmd $HISTFILE | sed 's/^: [0-9]*:[0-9]*;//' \
    | peco --query "$LBUFFER")"

  if [ x"${selected}" != x ]; then
    BUFFER="${selected}"
    CURSOR=$#BUFFER         # move cursor
    zle -R -c               # refresh
  fi
}

zle -N peco-select-history
