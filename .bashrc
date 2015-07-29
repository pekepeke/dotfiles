# ~/.bashrc: executed by bash(1) for non-login shells.
case $OSTYPE in
  cygwin*|msys*)
  PATH=$(echo $PATH | sed -e 's/\\\? /\\ /g')
  [ -e "$USERPROFILE/.pik/.pikrc" ] && source "$USERPROFILE/.pik/.pikrc"
  [ -e "$USERPROFILE/.pik/pik.sh" ] && source "$USERPROFILE/.pik/pik.sh"
  ;;
  darwin*)
    if [ -z "$BREW_PREFIX" ]; then
      [ -e /usr/local/Library/Contributions/brew_bash_completion.sh ] \
       && source /usr/local/Library/Contributions/brew_bash_completion.sh
    else
      [ -e "$BREW_PREFIX/Library/Contributions/brew_bash_completion.sh" ] \
        && source "$BREW_PREFIX/Library/Contributions/brew_bash_completion.sh"
    fi
    ;;
esac
[ -s $HOME/.shrc.languages ] && source $HOME/.shrc.languages

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#[ -n $(which zsh) ] && exec zsh
#[ -e /bin/which -a $(ps |grep zsh|grep -v grep| wc -l) -eq 0 ] && which zsh >/dev/null 2>&1 && exec zsh

[ -s $HOME/.shrc.boot ] && source $HOME/.shrc.boot
[ -s $HOME/.shrc.functions ] && source $HOME/.shrc.functions

## common settings {{{1
# disable auto logout {{{2
export TMOUT=0

set nobeep
set -o ignoreeof
unset autologout

# save dir stack {{{2
set savedirs
set implicitcd=verbose

set listjobs=long
set -o notify

# history {{{2
BLOCKSIZE=K
#FIGNORE='~:.o:,v'
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
HISTIGNORE="fg*:bg*:history*:cd*: *"
HISTTIMEFORMAT='%Y%m%d %T'


# etc settings {{{1
shopt -s checkwinsize

# /etc/hosts の代わり C-x @: 候補の一覧, Esc-@: 補完実行
# HOSTFILE=$HOME/etc/hosts

soft_source $HOME/.tmuxinator/scripts/tmuxinator
soft_source $HOME/.screeninator/scripts/screeninator

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## prompt {{{1
case $COLORTERM in
  gnome-terminal)
    TERM=xterm-256color
    ;;
esac

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
  xterm-256color) color_prompt=yes;;
esac

#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi
if [ -n "$SSH_CLIENT" ]; then
  ssh_text=" ssh"
fi

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w${ssh_text}\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W${ssh_text}\[\033[00m\]\$ '
else
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w${ssh_text}\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W${ssh_text}\$ '
fi
unset color_prompt force_color_prompt
unset ssh_text

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    # PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

## color {{{1
# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    #alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

## completion {{{1
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

## for completion
set autolist=ambiguous
set complete=enhance
set showdots
set symlinks=expand
set filec

# spell check
#set autocorrect
#set autoexpand
#set correct=cmd

#何も入力されていないときは補完しない
shopt -s no_empty_cmd_completion

#各コマンドの補完設定
complete -d cd
complete -c man
complete -c which
complete -c whatis
complete -c sudo
complete -v unset

PATH=$PATH:~/.bash/completion
for f in $(ls ~/.bash/completion); do
  complete -C $f -o nospace -o default ${f//-complete/}
done

source_all $HOME/.bash/commands/*
source_all $HOME/.bash/compfunc/*
complete -C aws_completer aws

# export {{{1
export PATH PS1 TERM \
  BLOCKSIZE FIGNORE \
  HISTSIZE HISTFILESIZE HISTCONTROL HISTIGNORE HISTTIMEFORMAT

# cd {{{1
# soft_source ~/.zsh/plugins/z/z.sh # too heavy..
cd() {
  builtin cd "$@"
  local ret=$?
  # ((ret)) || _z -add "$(pwd -P)"
  ((ret)) || _cdd_chpwd
  ((ret)) || _cd_hist_save_pwd
  return $ret
}

# peco {{{1
if type peco >/dev/null 2>&1; then
  # _peco_z_history() {
  #   local selected="$(_z -l 2>&1 | \
  #     peco | \
  #     perl -ne 's/[\r\n]+//g;s/^[0-9\.]* *//g;$d=m/ /?"\"":"";print "$d$_$d\n";' \
  #   )"
  #   if [ -n "$selected" ] ;then
  #     selected="cd \"$selected\""
  #     READLINE_LINE="$selected"
  #     READLINE_POINT=${#selected}
  #   fi
  # }
  _peco_dirs_history() {
    local selected="$(_cd_hist_list_dirs 2>&1 | \
      peco | \
      perl -ne 's/[\r\n]+//g;s/^\s*[0-9\.]*\s*//g;$d=m/ /?"\"":"";print "$d$_$d\n";' \
    )"
    if [ -n "$selected" ] ;then
      selected="cd \"$selected\""
      READLINE_LINE="$selected"
      READLINE_POINT=${#selected}
    fi
  }
  _peco_command_history() {
    local selected="$(HISTTIMEFORMAT= history | tac | sed -e 's/^\s*[0-9]\+\s\+//' | peco --query "$READLINE_LINE")"
    if [ -n "$selected" ] ;then
      READLINE_LINE="$selected"
      READLINE_POINT=${#selected}
    fi
  }
  # bind -x '"\C-xj":_peco_z_history'
  bind -x '"\C-xj":_peco_dirs_history'
  bind -x '"\C-r":_peco_command_history'
fi

# __END__ {{{1
# vim:fdm=marker sw=2 ts=2 ft=sh expandtab:
