# .zshrc

# prompt {{{1
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

# options {{{1
# cd {{{2
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

# completion {{{2
setopt no_beep
setopt no_list_beep

setopt auto_name_dirs       # enable ~/$var
setopt auto_menu            # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_slash     # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_keys      # カッコの対応などを自動的に補完
unsetopt cdable_vars        # not expand "~"
setopt mark_dirs            # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types           # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt interactive_comments # コマンドラインでも                                                                         # 以降をコメントと見なす
setopt complete_in_word     # 語の途中でもカーソル位置で補完
setopt always_last_prompt   # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt magic_equal_subst    # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる

setopt extended_glob        # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt globdots             # 明確なドットの指定なしで.から始まるファイルをマッチ

# i/o {{{2
#setopt correct 
setopt print_eight_bit      # 日本語ファイル名等8ビットを通す
setopt sun_keyboard_hack
#setopt interactive_comments
setopt no_nomatch

# prompting

# zle
unsetopt beep

#export WORDCHARS='*?_.[]~=&;!#$%^(){}<>'

# autoload {{{1
[ -e ~/.zsh/functions/completion ] && fpath=($HOME/.zsh/functions/completion $fpath)
autoload -U compinit
compinit -u

zstyle ':completion:*:default' menu select=2
#zstyle ':completion:*' list-colors di=34 fi=0
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

autoload -U zmv

autoload -U colors
colors

setopt no_flow_control
setopt no_beep
setopt ignore_eof
setopt auto_list
setopt extended_glob
setopt auto_cd
setopt auto_pushd
setopt no_tify

# keybinds {{{1
bindkey -v
# for command mode
bindkey -a 'O' push-line
bindkey -a 'H' run-help
bindkey -a '^A' beginning-of-line
bindkey -a '^E' end-of-line

## for insert mode
bindkey -v '^[OH' beginning-of-line
bindkey -v '^[OF' end-of-line
bindkey -v "\e[1~" begginning-of-line   # Home
bindkey -v "\e[4~" end-of-line          # End
bindkey -v "^[[3~" delete-char          # Del
bindkey -v "\e[Z" reverse-menu-complete # S-Tab
## emacs like
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
        ;&
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

  source ~/.zsh/cdd
  function chpwd(){
  if [[ $TERM = screen* ]];then
    echo -ne "k${PWD/${HOME}/~}\\"
  else
    echo -ne "\033]0;${PWD/${HOME}/~}\007"
  fi
  ls -A
  _reg_pwd_screennum
}
fi

# plugins {{{1
if [ -e ~/.zsh/completion/ ]; then
  for completion_sh in $(ls ~/.zsh/completion/*); do
    source $completion_sh
  done
fi
[ -e ~/.zsh/cdf ] && source ~/.zsh/cdf

# auto-fu.zsh {{{2
# とりあえず OFF る、、、文字制御が欲しい。。
if [ -z "x" -a -f "$HOME/.zsh/auto-fu.zsh/auto-fu.zsh" -a "$OSTYPE" != "cygwin" ]; then
  unsetopt sh_word_split
  zstyle ':completion:*' completer _oldlist _complete _expand _match _prefix _approximate _list _history

  AUTO_FU_NOCP=1 source $HOME/.zsh/auto-fu.zsh/auto-fu.zsh

  # enable.
  zle-line-init () {
    auto-fu-init
  }
  zle -N zle-line-init

  # http://d.hatena.ne.jp/tarao/20100823/1282543408
  #
  # delete unambiguous prefix when accepting line
  function afu+delete-unambiguous-prefix () {
    afu-clearing-maybe
    local buf; buf="$BUFFER"
    local bufc; bufc="$buffer_cur"
    [[ -z "$cursor_new" ]] && cursor_new=-1
    [[ "$buf[$cursor_new]" == ' ' ]] && return
    [[ "$buf[$cursor_new]" == '/' ]] && return
    ((afu_in_p == 1)) && [[ "$buf" != "$bufc" ]] && {
      # there are more than one completion candidates
      zle afu+complete-word
      [[ "$buf" == "$BUFFER" ]] && {
        # the completion suffix was an unambiguous prefix
        afu_in_p=0; buf="$bufc"
      }
      BUFFER="$buf"
      buffer_cur="$bufc"
    }
  }
  zle -N afu+delete-unambiguous-prefix
  function afu-ad-delete-unambiguous-prefix () {
    local afufun="$1"
    local code; code=$functions[$afufun]
    eval "function $afufun () { zle afu+delete-unambiguous-prefix; $code }"
  }
  afu-ad-delete-unambiguous-prefix afu+accept-line
  afu-ad-delete-unambiguous-prefix afu+accept-line-and-down-history
  afu-ad-delete-unambiguous-prefix afu+accept-and-hold
fi

# for ruby gems {{{2
function cdgem() {
  cd `echo $GEM_HOME/**gems/$1* | awk '{print $1}'`
}
compctl -K _cdgem cdgem
function _cdgem() {
  reply=(`find $GEM_HOME -type d|grep -e '/gems/[^/]*$'|xargs basename|sort -nr`)
}

# vim: fdm=marker sw=2 ts=2 et:
