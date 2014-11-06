# .boot
[ -e ~/.shrc.boot ] && source ~/.shrc.boot

shrc_section_title "init" #{{{1

if_compile ~/.shrc.*[^zwc]
if_compile ~/.zshenv
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

typeset -xT RUBYLIB ruby_path
typeset -U ruby_path
ruby_path=(./lib)

typeset -xT PYTHONPATH pyhon_path
typeset -U python_path
python_path=(./lib)

shrc_section_title "autoload" #{{{1
autoload -U zmv
alias zmv='noglob zmv -W'
alias zcp='noglob zmv -C'
alias zln='noglob zmv -L'
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

shrc_section_title "functions" #{{{1
ls_abbrev() {
  if [[ ! -r $PWD ]]; then
    return
  fi
  # -a : Do not ignore entries starting with ..
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-aCF' '--color=always')
  case "${OSTYPE}" in
    freebsd*|darwin*)
      if type gls > /dev/null 2>&1; then
        cmd_ls='gls'
      else
        # -G : Enable colorized output.
        opt_ls=('-aCFG')
      fi
      ;;
  esac

  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [ $ls_lines -gt 10 ]; then
    echo "$ls_result" | head -n 5
    echo '...'
    echo "$ls_result" | tail -n 5
    echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}


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
shrc_section_title "for command mode" #{{{3
bindkey -a 'O' push-line
bindkey -a 'H' run-help
bindkey -a '^A' beginning-of-line
bindkey -a '^E' end-of-line

## for insert mode {{{3
bindkey -v '^[OH' beginning-of-line
bindkey -v '^[OF' end-of-line
bindkey -v "\e[1~" begginning-of-line   # Home
bindkey -v "\e[4~" end-of-line          # End
bindkey -v "^[[3~" delete-char          # Del
bindkey -v "\e[Z" reverse-menu-complete # S-Tab

## emacs like {{{3
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

_copy-buffer() {
  local copy_cmd="xsel -b"
  type pbcopy >/dev/null && copy_cmd="pbcopy"
  type xclip >/dev/null && copy_cmd="xclip -i -selection clipboard"
  print -rn $BUFFER | eval $copy_cmd
  zle -M "copy : ${BUFFER}"
}
zle -N _copy-buffer
bindkey -v "^Xy" _copy-buffer

# surround.vimみたいにクォートで囲む <<< # {{{3
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
# WORDCHARS='*?[]_~=&;!#$%^(){}<>'
# WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

# コマンドラインの単語区切りを設定する <<< # {{{3
# http://d.hatena.ne.jp/sugyan/20100712/1278869962
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

# enter key {{{3
function _do-enter() {
  if [ -n "$BUFFER" ]; then
    zle accept-line
    return 0
  fi
  echo
  ls_abbrev

  # if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
  #   echo
  #   echo -e "\e[0;33m--- git status ---\e[0m"

  #   local CMD="git status -sb"
  #   if is_exec timeout; then
  #     timeout -k 1 $CMD
  #   else
  #     timeout.pl -t 1 $CMD
  #     [ $? -eq 2 ] && notify-send "Killed" "$CMD"
  #   fi
  # fi
  zle reset-prompt
  return 0
}
zle -N _do-enter
bindkey '^m' _do-enter

shrc_section_title "history setting" #{{{1
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end


export HISTFILE=$HOME/.cache/zsh_history
if [ ! -d ~/.cache ]; then
  mkdir ~/.cache
fi

export HISTSIZE=10000
export SAVEHIST=$HISTSIZE

setopt extended_history   # 実行時刻と実行時間も保存
setopt hist_no_store      # history は追加しない
# setopt hist_reduce_branks # スペースを詰める
setopt hist_save_no_dups  # 古いものと同じものは無視
setopt hist_ignore_all_dups # 古いものと同じものは削除
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
shrc_section_title "percol" #{{{2
if type type peco >/dev/null 2>&1; then
  source_all ~/.zsh/zfunc/peco/*.zsh
  bindkey -v '^Xp' peco-search-clipmenu
  bindkey -v '^Xs' peco-select-snippets
  bindkey '^R' peco-select-history
  bindkey '^Vgh' peco-select-zle-git
  bindkey '^Vgj' peco-git-ls-files
  bindkey '^Vgg' peco-git-changed-files
  bindkey '^Vgb' peco-git-recent-branches
  bindkey '^VgB' peco-git-recent-all-branches
  bindkey '^Vgl' peco-git-log
  bindkey '^Vgm' peco-git-ls-files
  bindkey '^O' peco-select-zle
  bindkey '^Vo' peco-select-zle
fi

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
  _zaw-init() {
    zaw
    bindkey -r '^V'

    unfunction "_zaw-init"

    bindkey -v '^V;' zaw
    bindkey -v '^Vj' zaw-z
    bindkey -v '^Vh' zaw-cheat

    bindkey -v '^Vtt' zaw-tmux
    bindkey -v '^Vtw' zaw-tmux-window
    bindkey -v '^Vtl' zaw-tmux-pane
    bindkey -v '^Vt=' zaw-tmux-layout
    bindkey -v '^Vt-' zaw-tmux-layout
    bindkey -v '^Vk' zaw-keybind

    (( $+functions[zaw-src-tmuxinator] )) && bindkey -v '^Vm' zaw-tmuxinator
    (( $+functions[zaw-src-finder] )) && bindkey -v '^Vf' zaw-finder
  }

  _zaw-init
  # zle -N _zaw-init
  # bindkey -v '^V' _zaw-init
fi
shrc_section_title "autojump" #{{{2
if [ -e ~/.zsh/plugins/z/z.sh ]; then
  _Z_CMD=j
  . ~/.zsh/plugins/z/z.sh
fi

shrc_section_title "zsh-syntax-highlighting" #{{{2
if [ -e ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


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
        # branch="%F{green}$branch%f"
        branch="%{$K{green} $branch%k"
      elif [[ -n "$vcs_info_msg_5_" ]]; then # unstaged
        # branch="%F{red}$branch%f"
        branch="%K{red} $branch%k"
      else
        # branch="%F{blue}$branch%f"
        branch="%K{blue} $branch%k"
      fi

      print -n "%F{white}%K{black} %25<..<"
      print -n "$vcs_info_msg_1_%F"
      print -n "%<<%k%f"

      print -n "%F{white}%K{black} | %25<..<"
      print -nD "$repos %k%f"
      print -n "$branch"
      print -n "%<<"

    else
      # print -nD "[%F{yellow}%60<..<%~%<<%f]"
      print -nD "%F{white}%K{black}%60<..< %~ %<<%k%f"
    fi
  }
else
  echo_rprompt() {
    # print -nD "[%F{yellow}%60<..<%~%<<%f]"
    print -nD "%F{white}%K{black}%60<..< %~ %<<%k%f"
  }
fi
precmd_rprompt() {
  RPROMPT=`echo_rprompt`
  # print -PnD "\e]1;%n@%m: %${PWD}\a"
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
        arg=":vagrant"
        ;;
      sudo)
        ;;
      su)
        arg="!root!"
        ;;
      *)
        ;;
    esac
    if [ -n "$arg" ]; then
      print -n "\ek${1%% *}$arg\e\\"
    fi
  fi
}

if is_exec notify-send; then
  notify-preexec-hook() {
    zsh_notifier_cmd="$1"
    if [[ "${zsh_notifier_cmd}" =~ "^(tmux|ssh|vim|telnet)" ]];then
      zsh_notifier_cmd=
      return
    fi
    zsh_notifier_time="`date +%s`"
  }

  notify-precmd-hook() {
    local time_taken

    if [[ "${zsh_notifier_cmd}" != "" ]]; then
      time_taken=$(( `date +%s` - ${zsh_notifier_time} ))
      if (( $time_taken > $REPORTTIME )); then
        notify-send "task finished" \
          "'$zsh_notifier_cmd' exited after $time_taken seconds"
      fi
    fi
    zsh_notifier_cmd=
  }
  add-zsh-hook preexec notify-preexec-hook
  add-zsh-hook precmd notify-precmd-hook
fi

# typeset -ga precmd_functions
add-zsh-hook precmd precmd_rprompt
# add-zsh-hook precmd precmd_multiterm

add-zsh-hook preexec preexec_multiterm
add-zsh-hook chpwd chpwd_multiterm

local __user='%{$bg[black]%}%{$fg[white]%} %n@%m %{$reset_color%}$ '

local vi_n="%{$bg[magenta]%}%{$fg_bold[white]%} N %{$reset_color%}"
local vi_i="%{$bg[blue]%}%{$fg_bold[white]%} I %{$reset_color%}"
function _zle-line-init _zle-keymap-select {
  case $KEYMAP in
    vicmd)
      PROMPT="${vi_n}${__user}"
    ;;
    main|viins)
      PROMPT="${vi_i}${__user}"
    ;;
  esac
  zle reset-prompt
}
zle -N _zle-line-init
zle -N _zle-keymap-select

PROMPT="${vi_i}${__user}"
RPROMPT=""
if [ -n "$SSH_CONNECTION" ] && [ $TERM =~ "screen" ] && [ -z "$TMUX" ]; then
  t_prefix="$HOST"
fi

shrc_section_title "complete" #{{{1
zcomp-reload() {
  rm -f $_comp_dumpfile && compinit && exec $SHELL
}

_zsh-complete-init() {
  shrc_section_title "complete-init start"

  [ -e ~/.zsh/plugins/zsh-completions ] && fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
  [ -e ~/.zsh/plugins/zsh-perl-completions ] && fpath=(~/.zsh/plugins/zsh-perl-completions $fpath)
  [ -e ~/.zsh/zfunc/completion ] && fpath=($HOME/.zsh/zfunc/completion $fpath)
  source_all ~/.zsh/commands/*
  (( $+functions[___main] )) || ___main() {} # for git

  if [ ! -e ~/.zsh.d ]; then
    mkdir -p ~/.zsh.d
    cp ~/.zsh/zfunc/tools/rb_optparse.zsh ~/.zsh.d/rb_optparse.zsh
  fi
  fpath=(~/.zsh.d/Completion $fpath)

  zmodload -i zsh/complist
  autoload -Uz compinit
  compinit -u

  autoload -U bashcompinit
  bashcompinit

  . ~/.zsh.d/rb_optparse.zsh

  # from bash
  # source_all $HOME/.bash/compfunc/*
  source_all $HOME/.zsh/zfunc/compfunc/*

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
  zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

  zstyle ':completion:*' list-separator '-->'
  zstyle ':completion:*:default' menu select=2
  zstyle ':completion:*:default' list-colors ""                   # 補完候補に色付け(""=default)
  # zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'  # 補完候補を曖昧検索
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[.]=*'  # 補完候補を曖昧検索
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

  # completion bindkeys {{{3
  # vi like
  # bindkey -M menuselect 'h' vi-backward-char
  # bindkey -M menuselect 'j' vi-down-line-or-history
  # bindkey -M menuselect 'k' vi-up-line-or-history
  # bindkey -M menuselect 'l' vi-forward-char
  bindkey -M menuselect '^N' vi-down-line-or-history
  bindkey -M menuselect '^P' vi-up-line-or-history
  # 3}}}

  # 2}}}

  unfunction "_zsh-complete-init"
  zle expand-or-complete
  bindkey -v '^I' expand-or-complete

  shrc_section_title "complete-init finish"
}
zle -N _zsh-complete-init
bindkey -v '^I' _zsh-complete-init

[ -e ~/.spm_completion ] && . ~/.spm_completion

shrc_section_title "finish"
# vim: ft=zsh fdm=marker sw=2 ts=2 et:
# __END__ #{{{1
