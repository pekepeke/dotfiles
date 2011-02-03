# -*- mode: sh; coding: utf-8; -*-
# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
#
# $Id: mrkn-bash_profile 3544 2007-12-24 15:54:24Z mrkn $

if [ -f /etc/profile ]; then
  . /etc/profile
fi

# the default umask is set in /etc/login.defs
#umask 022

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# prompt
PS1='\u@\h[\w]\$ '
PS9='\u@\h[\w]\$ '

BLOCKSIZE=K
#FIGNORE='~:.o:,v'
HISTSIZE=512
HISTFILESIZE=512
HISTCONTROL=ignoredups

# /etc/hosts の代りに補完候補として参照するファイル。IP はダミーで OK。
# C-x @: 候補の一覧, Esc-@: 補完実行
# HOSTFILE=$HOME/etc/hosts

# autologout を無効にする
TMOUT=0

export BASH_ENV PS1 PS2 PS3 BLOCKSIZE FIGNORE \
  HISTSIZE HISTFILESIZE HISTCONTROL \
  TMOUT \
  PS1 PS9

LV='-Ia -Kej -Oej -Dej -Pej -c'
export LV
