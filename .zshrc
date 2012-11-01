# .boot
[ -e ~/.shrc.boot ] && source ~/.shrc.boot

# functions {{{1
debug_timer() {
  # echo "$(date +'%s.%N') : $*"
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

autoload -U zmv

autoload -U colors
colors

# URL を自動エスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# keybinds {{{1
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
# complete {{{2
[ -e ~/.zsh/plugins/zsh-completions ] && fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
[ -e ~/.zsh/functions/completion ] && fpath=($HOME/.zsh/functions/completion $fpath)
source_all ~/.zsh/commands/*

# zaw {{{2
if [ -e ~/.zsh/plugins/zaw ] ; then
  # source ~/.zsh/plugins/zaw/zaw.zsh
  # source_all ~/.zsh/functions/zaw/*
  # zstyle ':filter-select' case-insensitive yes
  autoload -Uz zaw ; zle -N zaw
  zaw () {
    zaw-rc
    [[ "${WIDGET-}" != "" ]] || return
    zle zaw -K emacs -- "$@"
  }
  zaw-rc () {
    unfunction "$0"

    source ~/.zsh/plugins/zaw/zaw.zsh
    source_all ~/.zsh/functions/zaw/*

    zstyle ':filter-select' case-insensitive yes
  }
  zaw "$@"

  fpath+=~/.zsh/plugins/zaw
  # fpath+=~/.zsh/functions/zaw


  bindkey -v '^X^A' zaw-ack
  bindkey -v '^X^S' zaw-history

  bindkey -v '^X^X' zaw-z

  bindkey -v '^Xj' zaw-open-file
  bindkey -v '^Xr' zaw-git-files
  bindkey -v '^Xb' zaw-git-branches
  bindkey -v '^Xs' zaw-screens
  bindkey -v '^Xt' zaw-tmux
  bindkey -v '^Xk' zaw-keybind
  bindkey -v '^Xl' zaw-ssh

fi
# autojump {{{2
if [ -e ~/.zsh/plugins/z/z.sh ]; then
  _Z_CMD=j
  autoload -Uz $_Z_CMD ; zle -N $_Z_CMD
  $_Z_CMD () {
    z-rc
  }
  z-rc() {
    unfunction "$0"
    source ~/.zsh/plugins/z/z.sh
    precmd() {
      _z --add "$(pwd -P)"
    }
  }
  $_Z_CMD "$@"
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

# for ruby gems {{{2
if [ x$GEM_HOME != x ]; then
  function cdgem() {
    cd `echo $GEM_HOME/**gems/$1* | awk '{print $1}'`
  }
  compctl -K _cdgem cdgem
  function _cdgem() {
    reply=(`find $GEM_HOME -type d|grep -e '/gems/[^/]*$'|xargs basename|sort -nr`)
  }
fi


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
autoload -U compinit
compinit -u

autoload -U bashcompinit
bashcompinit

debug_timer "finish"
# vim: fdm=marker sw=2 ts=2 et:
