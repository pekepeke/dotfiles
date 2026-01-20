# .boot
_is_win=$(is_win; echo $?)


shrc_section_title "init" #{{{1
local _f
for _f in ~/.shrc.*[^zwc] ~/.zshenv ; do
  [ -f $_f ] && [ ! -e $_f.zwc -o $_f -nt $_f.zwc ] && zcompile $_f
done
[ -e ~/.zshrc.zwc ] && rm -f ~/.zshrc.zwc

if is_mac ; then
  remove_path /usr/local/bin /usr/bin /bin /usr/sbin /sbin /opt/X11/bin
  PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin
  export PATH
fi

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

typeset -U path cdpath fpath manpath sudo_path
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

# autoload utils {{{2
source ~/.zsh/zfunc/autoload.zsh
soft_source ~/.zsh/zfunc/autoload.local.zsh

generate-autoload() {
  local suffix
  for suffix in "" ".local" ; do
    autoload_f=~/.zsh/zfunc/autoload${suffix}.zsh
    echo -n "" > $autoload_f
    for dirname in commands; do
      realdirpath=~/.zsh/zfunc/$dirname${suffix}
      dirpath="\$HOME/.zsh/zfunc/$dirname${suffix}"

      echo "fpath+=$dirpath" >> $autoload_f
      for f in $realdirpath/*; do
        [ -d "$f" ] && continue
        basename=${f##*/}
        [ "$basename" = "*" ] && continue
        if [ "$basename" != "*.zsh" ]; then
          echo "autoload -Uz ${basename%.*}" >> $autoload_f
        fi
      done
    done
    for dirname in peco; do
      realdirpath=~/.zsh/zfunc/$dirname${suffix}
      dirpath="\$HOME/.zsh/zfunc/$dirname${suffix}"
      echo "fpath+=$dirpath" >> $autoload_f
      for f in $realdirpath/*; do
        [ -d "$f" ] && continue
        basename=${f##*/}
        [ "$basename" = "*" ] && continue
        if [ "$basename" != "*.zsh" ]; then
          echo "autoload -Uz ${basename%.*}" >> $autoload_f
          echo "zle -N ${basename%.*}" >> $autoload_f
        fi
      done
    done
  done
  source ~/.zshrc
}

shrc_section_title "setopt" #{{{1
if is_bashonwin ; then
  unsetopt BG_NICE
fi
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
# log                        # ログインはすぐに出力
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
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command timeout -sKILL 2 $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [ $ls_lines -gt 10 ]; then
    echo "$ls_result" | head -n 5
    echo '...'
    echo "$ls_result" | tail -n 5
    echo "$(command timeout -sKILL 2  ls -1 -A | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}


shrc_section_title "keybinds" #{{{1
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
bindkey -v "\e[1~" beginning-of-line   # Home
bindkey -v "^[[1~" beginning-of-line
bindkey -v "\e[4~" end-of-line          # End
bindkey -v "^[[4~" end-of-line
bindkey -v "^[[3~" delete-char          # Del
bindkey -v "\e[Z" reverse-menu-complete # S-Tab

# rxvt
bindkey -v "\e[8~" end-of-line
bindkey -v "\e[7~" beginning-of-line
# non RH/Debian xterm
bindkey -v "\eOH" beginning-of-line
bindkey -v "\eOF" end-of-line
# for freebsd console
bindkey -v "\e[H" beginning-of-line
bindkey -v "\e[F" end-of-line

## emacs like {{{3
bindkey -v '^D' delete-char
bindkey -v '^H' backward-delete-char
bindkey -v '^W' backward-kill-word
bindkey -v '^A' beginning-of-line
bindkey -v '^E' end-of-line
bindkey -v '^B' backward-char
bindkey -v '^F' forward-char
bindkey -v '^K' kill-line
bindkey -v '^Y' yank
bindkey -v '^S' history-incremental-search-forward
bindkey -v '^R' history-incremental-pattern-search-backward

_copy-buffer() {
  print -rn $BUFFER | pbcopy-wrapper
  zle -M "copy : ${BUFFER}"
}
zle -N _copy-buffer
bindkey -v "^Xy" _copy-buffer

_substitute-buffer() {
  emulate -LR zsh
  zle -R "Substitute:"
  local SEDARG="s"
  local key=""
  read -k key
  local -r start=$key
  while (( (#key)!=(##\n) && (#key)!=(##\r) )) ; do
    if (( (#key)==(##^?) || (#key)==(##^h) )) ; then
      SEDARG=${SEDARG[1,-2]}
    else
      SEDARG="${SEDARG}$key"
    fi
    zle -R "Substitution: $SEDARG"
    read -k key || return 1
  done
  BUFFER="$(echo $BUFFER | sed -r -e "$SEDARG")"
  zle redisplay
}
zle -N _substitute-buffer
zle -N substitute-buffer _substitute-buffer

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
    builtin zle .accept-line
    return 0
  fi
  # echo "$WIDGET"  "$LASTWIDGET"
  if [ "$WIDGET" != "$LASTWIDGET" ]; then
    ZSHRC_ENTER_COUNT=0
  fi
  # echo $ZSHRC_ENTER_COUNT
  case $[ZSHRC_ENTER_COUNT++] in
    0)
      # BUFFER=" ls_abbrev"
      echo ; ls_abbrev
      ;;
    1)
      if [[ -d .svn ]]; then
        # BUFFER=" svn status"
      elif command timeout -sKILL 2 git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # BUFFER=" git status -sb"
        echo ; command timeout -sKILL 2 git status -sb
      fi
      ;;
    *)
      builtin zle .accept-line
      unset ZSHRC_ENTER_COUNT
      ;;
  esac
  builtin zle .reset-prompt
  # builtin zle .accept-line
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
      # cd|ssh|rlwrap)
      #   if (( $#cmd >= 2)); then
      #     cmd[1]=$cmd[2]
      #   fi
      #   ;;
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
    (( $+functions[_reg_pwd_screennum] )) && _reg_pwd_screennum
  }
fi

shrc_section_title "plugins" #{{{1
shrc_section_title "zload" #{{{2
zload() {
    if [[ "${#}" -le 0 ]]; then
        echo "Usage: $0 PATH..."
        echo 'Load specified files as an autoloading function'
        return 1
    fi

    local file function_path function_name
    for file in "$@"; do
        if [[ -z "$file" ]]; then
            continue
        fi

        function_path="${file:h}"
        function_name="${file:t}"

        if (( $+functions[$function_name] )) ; then
            # "function_name" is defined
            unfunction "$function_name"
        fi
        FPATH="$function_path" autoload -Uz +X "$function_name"

        if [[ "$function_name" == _* ]]; then
            # "function_name" is a completion script

            # fpath requires absolute path
            # convert relative path to absolute path with :a modifier
            fpath=("${function_path:a}" $fpath) compinit
        fi
    done
}

shrc_section_title "peco" #{{{2
local isnt_mintty=$([[ "${MSYSCON} ${CYGWIN}" =~ mintty ]]; echo $?)
if ! type peco >/dev/null 2>&1; then
  if type fzf >/dev/null 2>&1 ; then
    peco() {
      fzf "$@"
    }
  elif type percol >/dev/null 2>&1 ;then
    peco() {
      percol "$@"
    }
  fi
fi
if [ $isnt_mintty -eq 1 ] && type peco >/dev/null 2>&1; then

  # source_all ~/.zsh/zfunc/peco/*.zsh
  bindkey -v '^Vp' peco-clipmenu-copy
  bindkey -v '^Vs' peco-snippets-copy
  bindkey -v '^Vx' peco-snippets-exec
  bindkey '^R' peco-history-replace-buffer
  bindkey '^Vw' peco-gui-window-select
  bindkey '^Vgh' peco-zle-git-launch
  bindkey '^Vgj' peco-git-ls-files-insert-at-pos
  bindkey '^Vgg' peco-git-changed-files-insert-at-pos
  bindkey '^Vbb' peco-git-branch-insert-at-pos
  bindkey '^Vbr' peco-git-branch-all-insert-at-pos
  bindkey '^Vgb' peco-git-recent-branches-all-insert-at-pos
  # bindkey '^Vgb' peco-git-recent-branches-replace-buffer
  # bindkey '^VgB' peco-git-recent-branches-all-replace-buffer
  bindkey '^Vgl' peco-git-log-hash-insert-at-pos
  bindkey '^Vgm' peco-git-ls-files-insert-at-pos
  bindkey '^O' peco-zle-launch
  bindkey '^Vo' peco-zle-launch
fi
if [ $isnt_mintty -eq 0 ]; then
  peco() {
    echo "unavailable command on mintty" 1>&2
    return 1
  }
fi

shrc_section_title "textobj" #{{{2
# source_all ~/.zsh/plugins/opp.zsh/opp.zsh
# source_all ~/.zsh/plugins/opp.zsh/opp/*

shrc_section_title "zaw" #{{{2
if [ -e ~/.zsh/plugins/zaw ] ; then
  autoload -Uz zaw ; zle -N zaw
  fpath+=~/.zsh/plugins/zaw
  fpath+=~/.zsh/zfunc

  _zaw-init() {
    zaw
    bindkey -r '^V'

    unfunction "_zaw-init"

    bindkey -v '^V;' zaw
    function _zi() { zi }; zle -N _zi
    function _cheat() {
      local _CAT=cat
      is_exec batcat && _CAT=batcat
      is_exec bat && _CAT=bat
      local selected="$(find ~/.zsh/opt/cheat ~/.zsh/opt/reference/source/_posts -type f | \
        fzf --preview "$_CAT {}" --bind "enter:become(echo $_CAT {})" \
        --bind 'ctrl-l:become(echo cat {})' \
        --bind 'ctrl-e:become(echo cat {} | fzf)' \
        --bind 'ctrl-y:execute-silent:(cat {} | pbcopy-wrapper)')"
      if [ "$selected" != "" ] ;then
        if [ "$selected[1,4]" == "less" ]; then
          eval $selected
        else
          eval $selected
          # | fzf --multi --bind 'enter:become(echo {} | pbcopy-wrapper)'
        fi
      fi
    }
    zle -N _cheat
    # bindkey -v '^Vj' zaw-z
    bindkey -v '^Vj' _zi
    # bindkey -v '^Vh' zaw-cheat
    bindkey -v '^Vh' _cheat

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
# shrc_section_title "autojump" #{{{2
# if [ -z "$ZSH_DISABLES[autojump]" -a -e ~/.zsh/plugins/z/z.sh ]; then
#   # if [ "$OSTYPE" != "msys" -a -z "$CYGWIN" ]; then
#   _Z_CMD=j
#   . ~/.zsh/plugins/z/z.sh
#   # fi
# fi

shrc_section_title "zsh-syntax-highlighting" #{{{2
if [ -z "ZSH_DISABLES[zsh-syntax-highlighting]" -a $_is_win -ne 0 -a -e ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


shrc_section_title "prompt" #{{{1
setopt prompt_subst      # PROMPT内で変数展開・コマンド置換・算術演算を実行
setopt prompt_percent    # %文字から始まる置換機能を有効にする
setopt transient_rprompt # コマンド実行後は右プロンプトを消す

# if [[ $ZSH_VERSION == (<5->|4.<4->|4.3.<10->)* ]]; then
if [ -z "$ZSH_DISABLES[vcs]" ] && is-at-least 4.3.10 ; then
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

      # branch="$vcs_info_msg_2_"
      branch="$vcs_info_msg_3_:$vcs_info_msg_2_"
      # [[ $vcs_info_msg_3_ =~ -svn ]] && branch="s:$branch"

      if [[ -n "$vcs_info_msg_4_" ]]; then # staged
        # branch="%F{green}$branch%f"
        branch="%F{black}%{$K{green} $branch%k%F{white}"
      elif [[ -n "$vcs_info_msg_5_" ]]; then # unstaged
        # branch="%F{red}$branch%f"
        branch="%F{black}%K{red} $branch%k%F{white}"
      else
        # branch="%F{blue}$branch%f"
        branch="%F{black}%K{blue} $branch%k%F{white}"
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
  # echo precmd_multiterm
  if [ $TERM =~ "screen" ]; then
    print -n "\ek${PWD/${HOME}/\~}\e\\"
  fi
}
chpwd_multiterm() {
  # echo chpwd_multiterm
  [ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#I") $PWD
}

preexec_multiterm() {
  # echo preexec_multiterm $1
  if [ $TERM =~ "screen" ]; then
    local arg
    case $1 in
      ssh*)
        if [ -z "$TMUX" ]; then
          arg="${1%% *}:$(awk '{print $NF}' <<< $1)"
        fi
        ;;
      telnet*)
        arg="${1%% *}:$(awk '{print $NF}' <<< $1)"
        ;;
      vagrant*)
        arg="${1#* }:vagrant"
        ;;
      sudo*)
        arg="${1#* }:sudo"
        # arg="$(awk '{print $2}' <<< $1 ):sudo"
        ;;
      su*)
        arg="${1#* }:!root!"
        # arg="$(awk '{print $2}' <<< $1 ):sudo"
        ;;
      tmux*|echo*|print*)
        ;;
      *)
        if [ -n "$TMUX" ]; then
          arg="$1"
        fi
        ;;
    esac
    if [ -n "$arg" ]; then
      if [ -n "$TMUX" ]; then
        tmux_pane_title=$(tmux display -p '#{pane_title}')
        printf '\033]2;%s\033\\' "$arg"
        # echo $arg
      else
        print -n "\ek$arg\e\\"
      fi
    fi
  fi
}

if is_exec notify-send; then
  notify-preexec-hook() {
    zsh_notifier_cmd="$1"
    if [[ "${zsh_notifier_cmd}" =~ "^(tmux|screen|ssh|vim|telnet)" ]];then
      unset zsh_notifier_cmd
      return
    fi
    zsh_notifier_time="`date +%s`"
  }

  notify-precmd-hook() {
    local time_taken

    if [ -n "${zsh_notifier_cmd}" ]; then
      time_taken=$(( `date +%s` - ${zsh_notifier_time} ))
      if (( $time_taken > $REPORTTIME )); then
        notify-send "task finished" \
          "'$zsh_notifier_cmd' exited after $time_taken seconds"
      fi
    fi
    if [ -n "$TMUX" -a -n "$tmux_pane_title" ]; then
      printf "\033]2;%s\033\\" "${tmux_pane_title}"
      unset tmux_pane_title
    fi
    unset zsh_notifier_cmd
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
[ -n "$MY_PROMPT" ] && __user="$MY_PROMPT"

local vi_n="%{$bg[red]%}%{$fg_bold[black]%} N %{$reset_color%}"
local vi_i="%{$bg[blue]%}%{$fg_bold[black]%} I %{$reset_color%}"
local vi_v="%{$bg[yellow]%}%{$fg_bold[black]%} V %{$reset_color%}"
function zle-line-init zle-keymap-select zle-line-finish {
  case $KEYMAP in
    vicmd)
      PROMPT="${vi_n}${__user}"
    ;;
    main|viins)
      PROMPT="${vi_i}${__user}"
      ;;
    vivis|vivli)
      PROMPT="${vi_v}${__user}"
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

PROMPT="${vi_i}${__user}"
RPROMPT=""
if [ -n "$SSH_CONNECTION" ] && [ $TERM =~ "screen" ] && [ -z "$TMUX" ]; then
  t_prefix="$HOST"
fi

shrc_section_title "complete" #{{{1

if [ -z "$ZSH_DISABLES[zsh-heavy-completions]" ]; then
  #  applied to later defined.
  # [ -e ~/.zsh/plugins/zsh-completions ] && fpath=(~/.zsh/plugins/zsh-completions/src $fpath)
  # [ -e ~/.zsh/plugins/zsh-perl-completions ] && fpath=(~/.zsh/plugins/zsh-perl-completions $fpath)
  [ -e ~/.zsh/plugins/zsh-completions ] && fpath+=~/.zsh/plugins/zsh-completions/src
  [ -e ~/.zsh/plugins/zsh-perl-completions ] && fpath+=~/.zsh/plugins/zsh-perl-completions
fi
# [ -e ~/.zsh/zfunc/completion ] && fpath=($HOME/.zsh/zfunc/completion $fpath)
[ -e ~/.zsh/zfunc/completion ] && fpath+=$HOME/.zsh/zfunc/completion
source_all ~/.zsh/zfunc/commands/*

(( $+functions[___main] )) || ___main() {} # for git

if [ -z "$BREW_PREFIX" ]; then
  fpath=(/usr/local/share/zsh/site-functions(N-/) ${fpath})
else
  fpath=($BREW_PREFIX/share/zsh/site-functions(N-/) ${fpath})
fi

if [ -z "$ZSH_DISABLES[zsh-heavy-completions]" ]; then
  if [ ! -e ~/.zsh.d ]; then
    mkdir -p ~/.zsh.d
    cp ~/.zsh/zfunc/tools/rb_optparse.zsh ~/.zsh.d/rb_optparse.zsh
  fi
  fpath=(~/.zsh.d/Completion $fpath)
fi

zmodload -i zsh/complist

# functions
zcomp-reload() {
  rm -f $_comp_dumpfile && compinit && exec $SHELL
}


_zsh-complete-init() {
  shrc_section_title "complete-init start"

  autoload -Uz compinit
  compinit -u

  compdef mosh=ssh
  # compdef ssh-log=ssh
  # compdef multi_ssh=ssh

  autoload -U bashcompinit
  bashcompinit

  if [ -z "$ZSH_DISABLES[zsh-heavy-completions]" ]; then
    . ~/.zsh.d/rb_optparse.zsh

    # from bash
    # source_all $HOME/.bash/compfunc/*
    source_all $HOME/.zsh/zfunc/compfunc/*
  fi

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
  zstyle ':completion:*:processes' command "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command" # kill
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


  [ -e ~/.spm_completion ] && . ~/.spm_completion
  if is_exec aws_zsh_completer.sh; then
    if [ -e "$HOMEBREW_PREFIX/Cellar/awscli" ]; then
      source $('ls' /usr/local/Cellar/awscli/*/libexec/bin/aws_zsh_completer.sh | sort | head -1)
    else
      source $(which aws_zsh_completer.sh)
    fi
  fi

  shrc_section_title "complete-init finish"
}
zle -N _zsh-complete-init
bindkey -v '^I' _zsh-complete-init

[ -e ~/.shrc.boot ] && source ~/.shrc.boot

shrc_section_title "finish"
type zprof >/dev/null 2>&1 && zprof | less
# vim: ft=zsh fdm=marker sw=2 ts=2 et:
# __END__ #{{{1
