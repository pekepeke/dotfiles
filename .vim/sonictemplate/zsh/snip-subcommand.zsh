compdef _{{_input_:command}} {{_input_:command}}
function _{{_input_:command}} {
  local -a cmds
  if (( CURRENT == 2 ));then
    cmds=('init' 'update' 'upgrade' 'commit')
    _describe -t commands "subcommand" cmds
  else
    _files
  fi

  return 1;
}
