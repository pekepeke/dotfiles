# ~/.bashrc: executed by bash(1) for non-login shells.

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
HISTSIZE=512
HISTFILESIZE=512
HISTCONTROL=ignoredups

export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
export HISTIGNORE="fg*:bg*:history*:cd*: *"
export HISTTIMEFORMAT='%Y%m%d %T'

export BLOCKSIZE FIGNORE \
  HISTSIZE HISTFILESIZE HISTCONTROL HISTIGNORE HISTTIMEFORMAT

# etc settings {{{1
shopt -s checkwinsize

# /etc/hosts の代わり C-x @: 候補の一覧, Esc-@: 補完実行
# HOSTFILE=$HOME/etc/hosts

soft_source $HOME/.tmuxinator/scripts/tmuxinator
soft_source $HOME/.screeninator/scripts/screeninator

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## prompt {{{1
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
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

# vim:fdm=marker sw=2 ts=2 ft=sh expandtab:
