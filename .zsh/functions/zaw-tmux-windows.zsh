#!zsh
# NAME
#        my-tmux-zaw.zsh - zaw-launcher.zsh wrapper for tmux
#
# SYNOPSIS
#        my-tmux-zaw.zsh [dispatch tmux-command]
#
# DESCRIPTION
#        You can select tmux's windows by using zaw with this command.
#
# INSTALL
#        . Add your zaw clone path to $fpath;
#
#        . Add zaw config file location to $fpath;
#          You can do this in ~/.zshenv:
#
#              fpath+=/c/zaw
#              fpath+=~/.zsh.d/zfunc
#
#        . Configure zaw with $fpath/zaw.
#          You can get a sample $fpath/zaw file with:
#
#              % zsh my-tmux-zaw.zsh show-zaw-config-sample
#
#          Please update your ~/.zshrc to reflect the configuration changes:
#
#              # move your zstyles abuot ':filter-select' to
#              # $fpath/zaw (in this case ~/.zsh.d/zfunc/zaw).
#              autoload -Uz zaw; zle -N zaw;
#
[[ "${1-}" != show-zaw-config-sample ]] || { cat -; exit } <<'EOT'
#!zsh
# This is an example of zaw config file (please sove as ${fpath}/zaw)
# aiming to share zaw's configrations with the interactive session, .zshrc.
# In .zshrc, you just add for example (place *this file* under ~/.zsh.d/zfunc):
#     autoload -Uz zaw; zle -N zaw
# and setup zaw like below inside zaw-rc ():

zaw () {
  zaw-rc
  [[ "${WIDGET-}" != "" ]] || return
  zle zaw -K emacs -- "$@"
}
zaw-rc () {
  unfunction "$0"
#  zstyle ':filter-select' extended-search yes
#  zstyle ':filter-select:highlight' selected fg=yellow,bg=blue,bold
#  zstyle ':filter-select:highlight' matched bg=111,bold
#  zstyle ':filter-select' max-lines -1

  source /c/zaw/zaw.zsh
#  eval "zaw~ () {
#    ${${functions[zaw]}/zle -R \"now loading ...\"/}
#  }"
#  zle -N zaw~
#  zaw () { zle zaw~ -K emacs -- "$@" }
#
#  eval "$({
#    autoload zargs
#    zargs -I{} -- \
#      ~/c/experiment/zsh/zaw-source/^.*(N) \
#      ~/c/experiment/zsh/840569/dirstack.zsh \
#      ~/c/experiment/zsh/851005/git-showbranch.zsh \
#      /c/people/tkf/zaw-sources/{zaw-cd-sub,zaw-hg-files,z}.zsh(N) \
#      -- \
#      echo source {}
#  })"
}
zaw "$@"
EOT
#
# EXAMPLES
#        Just fire the command inside tmux:
#
#            % zsh ~/.tmux.d/my-tmux-zaw.zsh
#            ... then zaw will come up eventually.
#
#        Use it with splited window:
#
#            % command tmux split-window "zsh ~/.tmux.d/my-tmux-zaw.zsh"
#
#        Give it some keybinds for example with the ~/.tmux.conf:
#        .   In this case,
#            prefix-'b': select windows on the new window and
#            prefix-'B': select windows on the splited window.
#
#            bind b if-shell \
#              "zsh ~/.tmux.d/my-tmux-zaw.zsh dispatch new-window" \
#              refresh-client
#            bind B split-window "zsh ~/.tmux.d/my-tmux-zaw.zsh"
#
# AUTHOR:
#         Takeshi Banse <takebi@laafc.net>
#
# LICENSE:
#         Public Domain
#

# Code:

if (( $# == 2 )) && [[ "$1" == dispatch ]]; then
  local -F SECONDS
  local tmpfile="${TMPPREFIX}-zaw-tmux-curprev-${$}-${RANDOM}-${SECONDS}"
  command tmux if-shell \
    "zsh ${0} save-curprev ${tmpfile}; true" \
    "if-shell 'zsh ${0} load-curprev ${tmpfile} ${2}' refresh-client"
  return 0
fi

with-piped-stdin-tmpfile () {
  local tmpfile="$1"; shift
  local edittmp="$1"; shift
  cat - >| "${tmpfile}"
  {
    "${edittmp}" "${tmpfile}"
    "$@"
  } always {
    rm -f "${tmpfile}"
  }
}

I () { }

tmux-edit-stdin-tmpfile-shift-current-window () {
  setopt localoptions extendedglob
  local MATCH MBEGIN MEND
  local -a ws
  : ${(A)ws::=${${(f)"$(<${1})"}:##[#!+~]#\**}} # cut off *this* window
  : ${(A)ws::=${ws/#(#m)[#!+~]#-/${MATCH/-/\*}}}
  local n="${PREVIOUSWINDOW-}"
  if [[ -n "${n-}" ]]; then
    : ${(A)ws::=${ws/#(#m)[#!+~ ]##${n}[^[:digit:]]/${${MATCH/ /}/${n}/-${n}}}}
  fi
  print -l ${ws} >| ${1}
}

zaw-call () {
  autoload -Uz +X zaw-launcher.zsh || {
    echo 'Please add your zaw clone path to $fpath.' >&2
    exit 1
  }
  eval \
    "zaw-launcher.zsh () { ${(S)functions[zaw-launcher.zsh]#source*zaw.zsh\"} }"
  local -F SECONDS
  local ZAWSTDINFILE="${TMPPREFIX}-zaw-${$}-${RANDOM}-${SECONDS}"
  local editproc="$1"; shift
  with-piped-stdin-tmpfile "${ZAWSTDINFILE}" "${editproc}" \
    zaw-launcher.zsh -e "$@"
}

zaw-src-stdin-tmux-list-windows () {
  : ${(A)candidates::=${(f)"$(<${ZAWSTDINFILE})"}}
  {
    A ()  { actions+=$1; act_descriptions+=$2 }
    A zaw-src-stdin-tmux-select-window "select"
    A zaw-src-stdin-tmux-swap-window "swap"
    A zaw-src-stdin-tmux-kill-window "kill"
    A zaw-src-stdin-tmux-link-window "link"
    A zaw-src-stdin-tmux-unlink-window "unlink"
  } always { unfunction A }
  options+=(-t "tmux windows")
  options+=(-p "(#s)[#!+~]#\**") # XXX: testing stuff
  options+=-m # XXX: used only by 'kill'
}

zaw-src-winum-call () { local n="${${1#?}%%:*}"; shift; "$@" "$n" }

zaw-src-stdin-tmux-select-window () {
  zaw-src-winum-call "$1" command tmux select-window -t
}

zaw-src-stdin-tmux-swap-window () {
  zaw-src-winum-call "$1" command tmux swap-window -d -s "$CURRENTWINDOW" -t
}

zaw-src-stdin-tmux-kill-window () {
  autoload -Uz zargs
  zargs -I{} -- ${(@)@}  -- \
    zaw-src-winum-call "{}" command tmux kill-window -t
}

zaw-src-stdin-tmux-link-window () {
  zaw-src-winum-call "$1" command tmux link-window -s
}

zaw-src-stdin-tmux-unlink-window () {
  zaw-src-winum-call "$1" command tmux unlink-window -t
}

tmux-curprev-windows-save () {
  local -a tmp; : ${(A)tmp::=${${(@f)"$(
    command tmux list-windows -F '#F#I'|grep '^[#!+~]*[\*|-]')"}}}
  : ${(P)1::="${${(M@)tmp:#\**}:1}"}
  : ${(P)2::="${${(M@)tmp:#-*}:1}"}
}

## entry point

(( $+functions[zaw] )) || {
  autoload -Uz +X zaw  || {
    echo 'Please add "${your zaw config path}:h" to $fpath.' >&2 
    exit 1
  }
  zaw
}
zaw-register-src -n tmux-windows zaw-src-stdin-tmux-list-windows

[[ "${NOEXEP-}" != t ]] || return

tmux-curprev-windows-save CURRENTWINDOW PREVIOUSWINDOW

if (( $# == 2 )) && [[ "$1" == save-curprev ]]; then
  exec > "${2}"
  cat <<EOT
CURRENTWINDOW=${CURRENTWINDOW}
PREVIOUSWINDOW=${PREVIOUSWINDOW}
EOT
  return 0
fi

local exe;: ${exe::=$(cat <<EOT
command tmux list-windows -F
  '#{window_flags}#{window_index}: #{window_name} _dq_#{pane_title}_dq_'
EOT)}
local s=;
if (( $# != 0 )); then
  local -A as
  as+=(new-window tmux-edit-stdin-tmpfile-shift-current-window)
  as+=(split-window I)
  local loadcurprevcode=;
  if (( $# > 2 )) && [[ "$1" == load-curprev ]]; then
    loadcurprevcode="source ${2}; rm -f ${2};"
    shift 2
  fi
  : ${s::=$(cat <<EOT
  command tmux ${1} "${exe} | zsh -c '
    NOEXEP=t;
    source ${0};
    CURRENTWINDOW=${CURRENTWINDOW};
    PREVIOUSWINDOW=${PREVIOUSWINDOW};
    ${loadcurprevcode}
    zaw-call ${as[${1}]} tmux-windows;
  '"
EOT)}
  exe=${s//_dq_/\\\"}
else
  s="$exe"
  s+="| zaw-call I tmux-windows"
  exe=${s//_dq_/\"}
fi
eval ${(z)exe[@]}
