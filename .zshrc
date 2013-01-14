# .boot
[ -e ~/.shrc.boot ] && source ~/.shrc.boot

# functions #{{{1
if_compile() {
  for f in $*; do
    [ ! -e $f.zwc -o $f -nt $f.zwc ] && zcompile $f
  done
}

shrc_section_title "init" #{{{1

if_compile ~/.shrc.*[^zwc]
if_compile ~/.zshenv
# if_compile ~/.zshrc
[ -e ~/.zshrc.zwc ] && rm -f ~/.zshrc.zwc

shrc_section_title "env vars" #{{{1
REPORTTIME=3                    # 3秒以上かかった処理は詳細表示
if [ $OSTYPE != "cygwin" -a -z $LANG ]; then
  export LANG=ja_JP.UTF-8
fi

case $OSTYPE in
  cygwin*)
    soft_source ~/.zsh/zfunc/init.cygwin.zsh ;;
  darwin*)
    soft_source ~/.zsh/zfunc/init.osx.zsh ;;
  bsd*)
    soft_source ~/.zsh/zfunc/init.bsd.zsh ;;
  linux*)
    soft_source ~/.zsh/zfunc/init.linux.zsh ;;
  solaris*)
    soft_source ~/.zsh/zfunc/init.solaris.zsh ;;
  *)
    ;;
esac

shrc_section_title "autoload" #{{{1
autoload -U zmv
autoload -Uz add-zsh-hook
autoload -U colors
autoload -Uz url-quote-magic
colors
zle -N self-insert url-quote-magic # URL を自動エスケープ

shrc_section_title "setopt" #{{{1
setopt auto_cd                  # ディレクトリ直入力で cd
setopt auto_pushd               # cd で pushd
setopt pushd_ignore_dups        # 同じ dir をスタックに入れない
setopt pushd_silent             # 静かに

# setopt correct                # スペルチェック
# setopt correct_all            # スペルチェックを全部に

setopt no_beep
setopt no_listbeep

setopt interactive_comments # コマンドラインでも # 以降をコメントと見なす

unsetopt cdable_vars        # not expand "~"
setopt brace_ccl            # {a-c} を展開

setopt multios              # 必要に応じて tee / cat

#setopt correct
setopt print_eight_bit      # 日本語ファイル名等8ビットを通す
setopt sun_keyboard_hack
#setopt interactive_comments
setopt no_nomatch

setopt no_flow_control     # 出力停止・開始(C-s/C-q)をOFF
setopt notify              # バックグラウンドジョブの状態変化を即時報告
setopt long_list_jobs      # jobs でプロセスIDも出力
watch="all"                # 全ユーザのログイン・ログアウトを監視
log                        # ログインはすぐに出力
setopt ignore_eof          # ^D でログアウトしない

shrc_section_title "keybinds" #{{{1
shrc_section_title "keybind from terminfo" #{{{2

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

shrc_section_title "keybind" #{{{2
bindkey -v
shrc_section_title "for command mode" #{{{2
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

# surround.vimみたいにクォートで囲む <<<
# http://d.hatena.ne.jp/mollifier/20091220/p1
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

# WORDCHARS='*?_-.[]~=&;!#$%^(){}'
WORDCHARS='*?[]~=&;!#$%^(){}<>'
# コマンドラインの単語区切りを設定する <<<
# http://d.hatena.ne.jp/sugyan/20100712/1278869962
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

# bindkey -e
# bindkey ";5C" forward-word
# bindkey ";5D" backward-word

shrc_section_title "history setting" #{{{1
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


export HISTFILE=$HOME/.tmp/.zsh_history
if [ ! -d ~/.tmp ]; then
  mkdir ~/.tmp
fi

export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

setopt extended_history   # 実行時刻と実行時間も保存
setopt hist_ignore_dups   # 同じコマンドラインは保存しない
setopt share_history      # プロセス間でヒストリを共有
setopt hist_ignore_space  # スペース始まりは追加しない
setopt hist_expand        # 補完時にヒストリを自動展開
setopt inc_append_history # すぐに追記

shrc_section_title "make coloring" #{{{2
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

shrc_section_title "plugins" #{{{1
shrc_section_title "textobj" #{{{2
# source_all ~/.zsh/plugins/opp.zsh/opp.zsh
# source_all ~/.zsh/plugins/opp.zsh/opp/*

shrc_section_title "zaw" #{{{2
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
  zaw-init
  # bindkey -v '^V' zaw-init
fi
shrc_section_title "autojump" #{{{2
if [ -e ~/.zsh/plugins/z/z.sh ]; then
  _Z_CMD=j
  . ~/.zsh/plugins/z/z.sh
  # autoload -Uz z ; zle -N z
  # z-init() {
  #   z
  #   # add-zsh-hook -d preexec z-init
  #   bindkey -v 'j' self-insert
  #   zle self-insert
  #   unfunction "z-init"
  # }

  # zle -N z-init
  # bindkey -v 'j' z-init
fi

shrc_section_title "zsh-syntax-highlighting" #{{{2
if [ -e ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

shrc_section_title "auto-fu.zsh" #{{{2
# if [ -e ~/.zsh/plugins/auto-fu.zsh ]; then
#   source ~/.zsh/plugins/auto-fu.zsh/auto-fu.zsh
#   zle-line-init() { auto-fu-init }
#   zle -N zle-line-init
#   zstyle ':completion:*' completer _oldlist _complete
#   zstyle ':auto-fu:var' postdisplay $''
#   zstyle ':auto-fu:highlight' completion fg=black,bold
#   zstyle ':auto-fu:highlight' completion/one fg=gray,normal,underline
# fi

shrc_section_title "prompt" #{{{1
setopt prompt_subst      # PROMPT内で変数展開・コマンド置換・算術演算を実行
setopt prompt_percent    # %文字から始まる置換機能を有効にする
setopt transient_rprompt # コマンド実行後は右プロンプトを消す

if [[ $ZSH_VERSION == (<5->|4.<4->|4.3.<10->)* ]]; then
  autoload -Uz vcs_info
  zstyle ':vcs_info:*' enable git svn hg
  zstyle ':vcs_info:bzr:*' use-simple true
  zstyle ':vcs_info:*' max-exports 7
  zstyle ':vcs_info:*' formats '%R' '%S' '%b' '%s'
  zstyle ':vcs_info:*' actionformats '%R' '%S' '%b|%a' '%s'
  zstyle ':vcs_info:*' check-for-changes true
  echo_rprompt () {
    local repos branch st color
    STY= LANG=en_US.UTF-8 vcs_info
    if [[ -n "$vcs_info_msg_1_" ]]; then
      # repos=`print -nD "$vcs_info_msg_0_"`
      repos=${vcs_info_msg_0_/${HOME}/\~}

      branch="$vcs_info_msg_2_"

      if [[ -n "$vcs_info_msg_4_" ]]; then # staged
        branch="%F{green}$branch%f"
      elif [[ -n "$vcs_info_msg_5_" ]]; then # unstaged
        branch="%F{red}$branch%f"
      else
        branch="%F{blue}$branch%f"
      fi

      print -n "[%25<..<"
      print -n "%F{yellow}$vcs_info_msg_1_%F"
      print -n "%<<]"

      print -n "[%25<..<"
      print -nD "%F{yellow}$repos%f"
      print -n "@$branch"
      print -n "%<<]"

    else
      print -nD "[%F{yellow}%60<..<%~%<<%f]"
    fi
  }
else
  echo_rprompt() {
    print -nD "[%F{yellow}%60<..<%~%<<%f]"
  }
fi
precmd_rprompt() {
  RPROMPT=`echo_rprompt`
  print -PnD "\e]1;%n@%m: %${PWD}\a"
  print -PnD "\e]1;%n@%m: %25<..<${PWD}%<<\a"
}

precmd_multiterm() {
  if [ $TERM =~ "screen" ]; then
    print -n "\ek${PWD/${HOME}/\~}\e\\"
  fi
}
chpwd_multiterm() {
  [ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#I") $PWD
}

preexec_multiterm() {
  if [ $TERM =~ "screen" ]; then
    local arg
    case $1 in
      ssh*|telnet*)
        arg=":$(awk '{print $NF}' <<< $1)"
        ;;
      vagrant*)
        arg=arg=":vagrant"
        ;;
      su*)
        arg="!root!"
        ;;
    esac
    if [ -n "$arg" ]; then
      print -n "\ek${1%% *}$arg\e\\"
    fi
  fi
}

# typeset -ga precmd_functions
add-zsh-hook precmd precmd_rprompt
# add-zsh-hook precmd precmd_multiterm
add-zsh-hook preexec preexec_multiterm
add-zsh-hook chpwd chpwd_multiterm
local __user='%{$fg[yellow]%}%n@%{$fg[yellow]%}%m%{$reset_color%}'

# export PROMPT="[%n@%m %3d]%(#.#.$) "
PROMPT="${__user}$ "
RPROMPT=""
# case "$TERM" in
#   cygwin|xterm|xterm*|kterm|mterm|rxvt*)
#     ;;
#   screen*)
#     ;;
# esac
if [ -n "$SSH_CONNECTION" ] && [ $TERM =~ "screen" ] && [ -z "$TMUX" ]; then
  t_prefix="$HOST"
fi

shrc_section_title "complete" #{{{1
zsh-complete-init() {
  shrc_section_title "complete-init start"

  [ -e ~/.zsh/plugins/zsh-completions ] && fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
  [ -e ~/.zsh/zfunc/completion ] && fpath=($HOME/.zsh/zfunc/completion $fpath)
  source_all ~/.zsh/commands/*

  autoload -U compinit
  compinit -u

  autoload -U bashcompinit
  bashcompinit

  # complete options {{{2
  setopt auto_list            # 一覧表示する
  setopt auto_name_dirs       # enable ~/$var
  setopt auto_menu            # 補完キー連打で順に補完候補を自動で補完
  setopt auto_param_slash     # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
  setopt auto_param_keys      # カッコの対応などを自動的に補完
  # setopt noautoremoveslash    # 末尾の / を自動で消さない
  setopt autoremoveslash    # 末尾の / を自動で消す

  setopt list_packed          # 補完候補を詰める
  setopt list_types           # 補完候補一覧でファイルの種別を識別マーク表示

  setopt complete_in_word     # 語の途中でもカーソル位置で補完
  setopt always_last_prompt   # カーソル位置は保持したままファイル名一覧を順次その場で表示
  setopt magic_equal_subst    # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
  setopt numeric_glob_sort    # 数字順で並べる

  setopt extended_glob        # 拡張グロブで補完
  # setopt mark_dirs            # ファイル名の展開でディレクトリにマッチした場合末尾に / を付加
  setopt globdots             # 明確なドットの指定なしで.から始まるファイルをマッチ

  # 高速化?
  zstyle ':completion:*' accept-exact '*(N)'                      # 展開方法
  zstyle ':completion:*' use-cache true                           # cache
  zstyle ':completion:*' verbose yes                              # verbose
  zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"     # sudo時にはsudo用のパスも使う。

  zstyle ':completion:*' list-separator '-->'
  zstyle ':completion:*:default' menu select=2
  zstyle ':completion:*:default' list-colors ""                   # 補完候補に色付け(""=default)
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'  # 補完候補を曖昧検索
  zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\ # '                              # 補完させない
  zstyle ':completion:*:cd:*' ignore-parents parent pwd # cd カレントディレクトリを選択しないので表示させないようにする (例: cd ../<TAB>):
  zstyle ':completion:*:manuals' separate-sections true # man のセクション番号を補完
  # 補完候補の優先度
  #
  ## _oldlist 前回の補完結果を再利用する。
  ## _complete: 補完する。
  ## _match: globを展開しないで候補の一覧から補完する。
  ## _history: ヒストリのコマンドも補完候補とする。
  ## _ignored: 補完候補にださないと指定したものも補完候補とする。
  ## _approximate: 似ている補完候補も補完候補とする。
  ## _prefix: カーソル位置で補完する。
  zstyle ':completion:*' completer _complete _oldlist _match _history _ignored _approximate _prefix
  # zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history

  # host completion {{{3
  # {{{
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
  zstyle ':completion:*' hosts $hosts #3}}}
  # 2}}}
  # etc completion {{{2
  is_exec hub && source ~/.zsh/zfunc/hub.zsh_completion
  # 2}}}

  unfunction "zsh-complete-init"
  # add-zsh-hook -d precmd zsh-complete-init
  zle expand-or-complete
  bindkey -v '^I' expand-or-complete
  shrc_section_title "complete-init finish"
}
# add-zsh-hook precmd zsh-complete-init
zle -N zsh-complete-init
bindkey -v '^I' zsh-complete-init
#_zsh-complete-init

shrc_section_title "finish"
# vim: ft=zsh fdm=marker sw=2 ts=2 et:
# __END__ #{{{1
