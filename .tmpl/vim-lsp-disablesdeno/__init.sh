#!/bin/bash

main() {
  if [ ! -e package.json ]; then
    echo "file not found: package.json" 1>&2
    exit 1
  fi
  [ ! -d .vim-lsp-settings ] && mkdir .vim-lsp-settings
  if [ ! -e .vim-lsp-settings/settings.json ]; then
    cat <<EOM >.vim-lsp-settings/settings.json
{
  "deno": {
    "disabled": true
  }
}
EOM
    echo "created: .vim-lsp-settings/settings.json"
  else
    echo "already exists:  .vim-lsp-settings/settings.json" 1>&2
  fi
  exit 0
}

main "$@"
