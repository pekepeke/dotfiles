# .boot
[ -e ~/.shrc.boot ] && source ~/.shrc.boot

# functions {{{1
debug_timer() {
  # echo "$(date +'%s.%N') : $*"
  return 0
}
if_compile() {
  for f in $* ; do
    [ ! -e $f.zwc ]  && zcompile $f
    [ $f -nt $f.zwc ] && zcompile $f
  done
}
source_all() {
  for f in $* ; do
    source $f
  done
}

debug_timer "start"

if_compile ~/.shrc.*[^zwc]
if_compile ~/.zshenv
# if_compile ~/.zshrc
[ -e ~/.zshrc.zwc ] && rm ~/.zshrc.zwc

# # https://github.com/zsh-users/antigen.git {{{1
# if [ -e ~/.zsh/antigen/antigen.zsh ]; then
#   source ~/.zsh/antigen/antigen.zsh
#   antigen-bundle brew
#   antigen-bundle git
# 
#   antigen-bundle pip
#   antigen-bundle perl
#   antigen-bundle cpanm
# 
#   antigen-bundle heroku
#   antigen-bundle ruby
#   antigen-bundle rbenv
#   antigen-bundle rake
#   antigen-bundle gem
#   antigen-bundle cap
#   antigen-bundle bundler
# 
#   antigen-bundle kennethreitz/autoenv
#   antigen-bundle vagrant
# 
#   antigen-bundle zsh-users/zsh-syntax-highlighting
#   antigen-bundle hchbaw/opp.zsh
# 
#   # antigen-theme funky
# 
#   antigen-apply
# fi

# env vars {{{1
REPORTTIME=3                    # 3秒以上かかった処理は詳細表示

# setopt {{{1
setopt auto_cd                  # ディレクトリ直入力で cd
setopt auto_pushd               # cd で pushd
setopt pushd_ignore_dups        # 同じ dir をスタックに入れない
setopt pushd_silent             # 静かに

# setopt correct                # スペルチェック
# setopt correct_all            # スペルチェックを全部に

setopt no_beep
setopt no_listbeep
setopt list_packed          # 補完候補を詰める

setopt auto_list            # 一覧表示する
setopt auto_name_dirs       # enable ~/$var
setopt auto_menu            # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_slash     # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_keys      # カッコの対応などを自動的に補完
unsetopt cdable_vars        # not expand "~"
setopt mark_dirs            # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types           # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt interactive_comments # コマンドラインでも # 以降をコメントと見なす
setopt complete_in_word     # 語の途中でもカーソル位置で補完
setopt always_last_prompt   # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt magic_equal_subst    # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

setopt extended_glob        # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt globdots             # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt brace_ccl            # {a-c} を展開

setopt multios              # 必要に応じて tee / cat
setopt noautoremoveslash    # 末尾の / を自動で消さない

#setopt correct 
setopt print_eight_bit      # 日本語ファイル名等8ビットを通す
setopt sun_keyboard_hack
#setopt interactive_comments
setopt no_nomatch

setopt no_flow_control
setopt ignore_eof
setopt no_tify

# prompting

# zle
unsetopt beep

#export WORDCHARS='*?_.[]~=&;!#$%^(){}<>'

# complete & autoload {{{1
# 高速化?
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache true

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:default' menu select=2
#zstyle ':completion:*' list-colors di=34 fi=0
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# host completion {{{
: ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}
[ -e ~/.ssh/config ] && : ${(A)_ssh_config_hosts:=${${${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
# this supposes you have "HashKnownHosts no" in your ~/.ssh/config
if [ -e ~/.ssh/known_hosts ]; then
  : ${(A)_ssh_known_hosts:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}}
  : ${(A)_ssh_known_ips:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}##*,}}
fi
hosts=(
  "$_ssh_config_hosts[@]"
  "$_ssh_known_hosts[@]"
  "$_etc_hosts[@]"
  "$_ssh_known_ips[@]"
  )
zstyle ':completion:*' hosts $hosts

autoload -U zmv
autoload -Uz add-zsh-hook
autoload -U colors
colors

# URL を自動エスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# keybinds {{{1
# keybind from terminfo {{{2

# typeset -A key
# 
# key[Home]=${terminfo[khome]}
# key[End]=${terminfo[kend]}
# key[Insert]=${terminfo[kich1]}
# key[Delete]=${terminfo[kdch1]}
# key[Up]=${terminfo[kcuu1]}
# key[Down]=${terminfo[kcud1]}
# key[Left]=${terminfo[kcub1]}
# key[Right]=${terminfo[kcuf1]}
# key[PageUp]=${terminfo[kpp]}
# key[PageDown]=${terminfo[knp]}
# 
# # setup key accordingly
# [[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
# [[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
# [[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
# [[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
# [[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
# [[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
# [[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
# [[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
# 
# # Finally, make sure the terminal is in application mode, when zle is
# # active. Only then are the values from $terminfo valid.
# function zle-line-init () {
#     echoti smkx
# }
# function zle-line-finish () {
#     echoti rmkx
# }
# zle -N zle-line-init
# zle -N zle-line-finish  

# keybind {{{2
bindkey -v
# for command mode {{{2
bindkey -a 'O' push-line
bindkey -a 'H' run-help
bindkey -a '^A' beginning-of-line
bindkey -a '^E' end-of-line

## for insert mode {{{2
bindkey -v '^[OH' beginning-of-line
bindkey -v '^[OF' end-of-line
bindkey -v "\e[1~" begginning-of-line   # Home
bindkey -v "\e[4~" end-of-line          # End
bindkey -v "^[[3~" delete-char          # Del
bindkey -v "\e[Z" reverse-menu-complete # S-Tab
## emacs like {{{2
bindkey -v '^D' delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^A' beginning-of-line
bindkey -v '^E' end-of-line
bindkey -v '^B' backward-char
bindkey -v '^F' forward-char
bindkey -v '^K' kill-line
bindkey -v '^S' history-incremental-search-forward
bindkey -v '^Y' yank
bindkey -v '^R' history-incremental-pattern-search-backward

autoload -U modify-current-argument
# シングルクォート用
_quote-previous-word-in-single() {
    modify-current-argument '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey -v '^[s' _quote-previous-word-in-single

# ダブルクォート用
_quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey -v '^[d' _quote-previous-word-in-double

# bindkey -e
# bindkey ";5C" forward-word
# bindkey ";5D" backward-word

export WORDCHARS='*?[]~=&;!#$%^(){}<>'

# history setting {{{1
debug_timer "start history"
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


export HISTFILE=$HOME/.tmp/.zsh_history
if [ ! -d $(dirname "$HISTFILE") ]; then
  mkdir $(dirname "$HISTFILE")
fi

export SAVEHIST=1000
export HISTSIZE=8192

setopt hist_ignore_dups
setopt share_history
setopt hist_ignore_space
setopt hist_expand

# make coloring {{{2
e_normal=`echo -e "\033[0;30m"`
e_RED=`echo -e "\033[1;31m"`
e_BLUE=`echo -e "\033[1;36m"`

function make() {
  LANG=C command make "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot\sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}
function cwaf() {
  LANG=C command ./waf "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot\sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}

if [[ "$TERM" == "screen" || "$TERM" == "screen-bce" ]]; then
  preexec() {
    # see [zsh-workers:13180]
    # http://www.zsh.org/mla/workers/2000/msg03993.html
    emulate -L zsh
    local -a cmd; cmd=(${(z)2})
    case $cmd[1] in
      fg)
        if (( $#cmd == 1 )); then
          cmd=(builtin jobs -l %+)
        else
          cmd=(builtin jobs -l $cmd[2])
        fi
        ;;
      %*) 
        cmd=(builtin jobs -l $cmd[1])
        ;;
      emacsclient)
        screen -X eval "select 1"
        return
        ;;
      cd|ssh|rlwrap)
        if (( $#cmd >= 2)); then
          cmd[1]=$cmd[2]
        fi
        ;;
      *)
        echo -n "k$cmd[1]:t\\"
        return
        ;;
    esac

    local -A jt; jt=(${(kv)jobtexts})

    $cmd >>(read num rest
    cmd=(${(z)${(e):-\$jt$num}})
    echo -n "k$cmd[1]:t\\") 2>/dev/null
  }

  function chpwd(){
    if [[ $TERM = screen* ]];then
      echo -ne "k${PWD/${HOME}/~}\\"
    else
      echo -ne "\033]0;${PWD/${HOME}/~}\007"
    fi
    #ls -A
    _reg_pwd_screennum
  }
fi

# plugins {{{1
debug_timer "start plugins"
# textobj {{{2
# source_all ~/.zsh/plugins/opp.zsh/opp.zsh
# source_all ~/.zsh/plugins/opp.zsh/opp/*

# zaw {{{2
if [ -e ~/.zsh/plugins/zaw ] ; then
  autoload -Uz zaw ; zle -N zaw
  fpath+=~/.zsh/plugins/zaw
  fpath+=~/.zsh/zfunc

  # source ~/.zsh/plugins/zaw/zaw.zsh
  # source_all ~/.zsh/functions/zaw/*
  # zstyle ':filter-select' case-insensitive yes
  zaw-init() {
    zaw
    # add-zsh-hook -d preexec zaw-init
    bindkey -r '^V'
    (( $+functions[z-init] )) && zle z-init

    unfunction "zaw-init"
  }

  # add-zsh-hook preexec zaw-init
  # zaw-init
  zle -N zaw-init
  bindkey -v '^V' zaw-init
fi
# autojump {{{2
if [ -e ~/.zsh/plugins/z/z.sh ]; then
  _Z_CMD=j
  autoload -Uz z ; zle -N z
  z-init() {
    z
    # add-zsh-hook -d preexec z-init
    bindkey -v 'j' self-insert
    zle self-insert
    unfunction "z-init"
  }

  # add-zsh-hook preexec z-init
  # z-init
  zle -N z-init
  bindkey -v 'j' z-init
fi

# auto-fu.zsh {{{2
# if [ -e ~/.zsh/plugins/auto-fu.zsh ]; then
#   source ~/.zsh/plugins/auto-fu.zsh/auto-fu.zsh
#   zle-line-init() { auto-fu-init }
#   zle -N zle-line-init
#   zstyle ':completion:*' completer _oldlist _complete
#   zstyle ':auto-fu:var' postdisplay $''
#   zstyle ':auto-fu:highlight' completion fg=black,bold
#   zstyle ':auto-fu:highlight' completion/one fg=gray,normal,underline
# fi

# prompt {{{1
debug_timer "start prompt"
export PROMPT="[%n@%m %3d]%(#.#.$) "

if [ $OSTYPE != "cygwin" -a -z $LANG ]; then
    export LANG=ja_JP.UTF-8
fi

setopt prompt_subst

case "$TERM" in
  cygwin|xterm|xterm*|kterm|mterm|rxvt*)
    #PROMPT='%{[33m%}%m%B[%D %T]%b%{[m%}\$ '
    PROMPT='%{[33m%}%n@%m%B%b%{[m%}\$ '
    RPROMPT='[%{[33m%}%4c%{[m%}]'
    ;;
  screen*)
    #PROMPT='%{[33m%}%m%B[%D %T]%b%{[m%}\$ '
    PROMPT='%{[33m%}%n@%m%B%b%{[m%}\$ '
    RPROMPT='[%{[33m%}%4c%{[mk%c\\%}]'
    ;;
esac

# compinit {{{1
debug_timer "start compinit"
zsh-complete-init() {
  debug_timer "complete-init start"

  [ -e ~/.zsh/plugins/zsh-completions ] && fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
  [ -e ~/.zsh/zfunc/completion ] && fpath=($HOME/.zsh/zfunc/completion $fpath)
  source_all ~/.zsh/commands/*

  autoload -U compinit
  compinit -u

  autoload -U bashcompinit
  bashcompinit

  unfunction "zsh-complete-init"

  # add-zsh-hook -d precmd zsh-complete-init
  zle expand-or-complete
  bindkey -v '^I' expand-or-complete
  debug_timer "complete-init finish"
}
# add-zsh-hook precmd zsh-complete-init
zle -N zsh-complete-init
bindkey -v '^I' zsh-complete-init
#_zsh-complete-init

debug_timer "finish"
# vim: ft=zsh fdm=marker sw=2 ts=2 et:
