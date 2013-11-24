# source local settings
# init {{{1
# [ $SHLVL -gt 1 ] && return 0
[ -f $HOME/.shrc.functions ] && source $HOME/.shrc.functions

if [ -f $HOME/.shrc.local ] ; then
  source $HOME/.shrc.local
else
  touch $HOME/.shrc.local
fi

shrc_section_title "ostype" #{{{1
export TMUX_DEFAULT_COMMAND=$SHELL
case $OSTYPE in
  cygwin*)
    ;;
  msys*)
    ;;
  darwin*)
    if type reattach-to-user-namespace >/dev/null 2>&1; then
      export TMUX_DEFAULT_COMMAND="reattach-to-user-namespace -l $SHELL"
      export TMUX_PREFIX_COMMAND="reattach-to-user-namespace"
      if [ -n "$TMUX" ]; then
        # exec reattach-to-user-namespace -l $SHELL
        tmux rename-window "$HOST"
        # alias mvim="reattach-to-user-namespace -l mvim"
        # alias vim="reattach-to-user-namespace -l vim"
        # alias emacs="reattach-to-user-namespace -l emacs"
      fi
    fi
    ;;
  freebsd*)
    ;;
  linux*)
    ;;
  solaris*)
    ;;
  *)
    ;;
esac

shrc_section_title "environments" #{{{1
export EDITOR="vim -u ~/.vimpagerrc"
# stty
if type stty >/dev/null 2>&1; then
  stty stop undef
  stty werase undef
fi

if [ ! -e "$TERMINFO" -a -e "/usr/share/terminfo" ]; then
  export TERMINFO=/usr/share/terminfo
fi

# for mysql
export MYSQL_PS1='\u@\h.\d mysql:\c> '

if is_colinux; then
  alias umount-c='sudo umount /c'
  alias mount-c='mount-c-smbfs'
  alias mount-c-cofs='sudo mount -t cofs cofs0 /c -o defaults,noatime,noexec,user,uid=$USER,gid=users'
  alias mount-c-smbfs='sudo mount -t smbfs "//windows/C\$" /c -o defaults,noatime,user,uid=$USER,gid=users,fmask=0644,dmask=0755,username=$USER'
  alias shutdown-colinux='sudo halt; exit'
fi

shrc_section_title "color" #{{{1
# enable color support of ls and also add handy aliases
## options {{{2
GREP_OPTIONS="--binary-files=without-match --exclude=\*.tmp"
# GREP_OPTIONS="--directories=recurse $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.svn $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.git $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.hg $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.deps $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.libs $GREP_OPTIONS"

LS_OPTIONS="--show-control-chars"

if [ "$TERM" != "dumb" ]; then
  if [ -z "$MSYSTEM" -a -x /usr/bin/dircolors ]; then
    [ -e ~/.dir_colors ] && eval `dircolors ~/.dir_colors -b`
    #   # eval "`dircolors -b`"
  fi
  #alias dir='ls --color=auto --format=vertical'
  #alias vdir='ls --color=auto --format=long'

  export GREP_COLOR='1;37;41'
  #alias fgrep='fgrep --color=auto'
  #alias egrep='egrep --color=auto'
  GREP_OPTIONS="--color=auto $GREP_OPTIONS"

  LS_OPTIONS="--color=always $LS_OPTIONS"
fi
export GREP_OPTIONS
export LS_OPTIONS

shrc_section_title "aliases" #{{{1
shrc_section_title "notify" #{{{2

shrc_section_title "basic commands" #{{{2
if is_exec gls; then
  alias ls="gls $LS_OPTIONS"
  alias ll="gls -l $LS_OPTIONS"
  alias la="gls -A $LS_OPTIONS"
  alias l="bls -CF $LS_OPTIONS"
else
  alias ls="ls $LS_OPTIONS"
  alias ll="ls -l $LS_OPTIONS"
  alias la="ls -A $LS_OPTIONS"
  alias l="ls -CF $LS_OPTIONS"
fi

alias today='date +%Y%m%d'

alias ..='cd ..'

alias cp='cp -ip'
alias rm=' rm -i'
alias mv='mv -i'
alias sudo=' sudo -H'
alias telnet='telnet -K'
alias ack='ack-grep'
alias less='less -R'

shrc_section_title "vim" #{{{2
if type lv > /dev/null 2>&1; then
  export PAGER=lv
  export LV="-c -l"
else
  alias lv="$PAGER"
fi
# if [ -x ~/bin/vimpager ] ; then
#   export PAGER=~/bin/vimpager
#   # alias less=$PAGER
#   # alias zless=$PAGER
# fi
alias vimfiler='vim -u ~/.vimrc.min -c VimFiler'
alias vimshell='vim -u ~/.vimrc.min -c VimShell'

alias vimrcinspect='vim --startuptime "$HOME/vimrc-read.txt" +q && vim vimrc-read.txt'
alias vimrcprofile='vim --cmd "profile start vimrc-profile.txt" --cmd "profile file $HOME/.vimrc" +q && vim vimrc-profile.txt'
alias vimrcprofileall='vim --cmd "profile start vimrc-profileall.txt" --cmd "profile! file $HOME/.vimrc" +q && vim vimrc-profileall.txt'
alias vimsafe='vim -u NONE -i NONE'
alias vimnone='vim -u NONE'
alias vimmin='vim -u ~/.vimrc.min'
alias vi='vim -u ~/.vimrc.min'
alias view='view -u ~/.vimrc.min'
alias ctags-rb='ctags --langmap=RUBY:.rb --exclude="*.js"  --exclude=".git*"'
gvi () {
  if is_mac ;then
    command mvim --remote-silent "$@" || mvim "$@"
  else
    command gvim --remote-silent "$@" || gvim "$@"
  fi
}

vundle-each() { #{{{3
  local f cwd=$(pwd)
  local subcommand=$1
  if [ x"" = x"$1" ]; then
    echo "subcommand not found : $1" 1>&2
  fi
  # for f in $(find ~/.vim/neobundle -depth 1 -type d); do
  for f in $(ls --color=no ~/.vim/neobundle); do
    f=~/.vim/neobundle/$f
    [ ! -d $f ] && continue
    echo $f
    cd $f
    [ -e .git ] && git $@
  done
  cd $cwd
}

shrc_section_title "emacs" #{{{2
## Invoke the ``dired'' of current working directory in Emacs buffer.
dired () { #{{{3
  emacsclient -e "(dired \"${1:a}\")"
}

## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
cde() { #{{{3
    local EMACS_CWD=`emacsclient -e "
     (expand-file-name
      (with-current-buffer
          (if (featurep 'elscreen)
              (let* ((frame-confs (elscreen-get-frame-confs (selected-frame)))
                     (num (nth 1 (assoc 'screen-history frame-confs)))
                     (cur-window-conf (cadr (assoc num (assoc 'screen-property frame-confs))))
                     (marker (nth 2 cur-window-conf)))
                (marker-buffer marker))
            (nth 1
                 (assoc 'buffer-list
                        (nth 1 (nth 1 (current-frame-configuration))))))
        default-directory))" | sed 's/^"\(.*\)"$/\1/'`

    echo "chdir to $EMACS_CWD"
    cd "$EMACS_CWD"
}

shrc_section_title "lang" #{{{2

is_exec rails && alias r=rails
alias jsprove='prove --ext=.t.js --exec=node'
alias phpprove='prove --ext=.t.php --exec=php'

alias iperl='perl -de0'
alias iphp='php -a'
alias rol='ruby -n -e '
perlmodules() {
  cat `perldoc -l perllocal` | perl -nle '/C<Module> L<([^\|]*?)\|.*?>/ and print "$1"'
}

shrc_section_title "etc" #{{{2
alias rsync='rsync -avzu'
alias adbchrome='adb forward tcp:92222 localabstract:chrome_devtools_remote'

shrc_section_title "display charset" #{{{2
alias utf8='export LANG=ja_JP.UTF-8; export LANGUAGE=ja_JP.UTF-8; export LC_ALL=ja_JP.UTF-8'
alias euc='export LANG=ja_JP.EUC; export LANGUAGE=ja_JP.EUC; export LC_ALL=ja_JP.EUC'
alias en='export LANG=en; export LANGUAGE=en; export LC_ALL=en'

shrc_section_title "compass" #{{{3
alias compass_scss='compass create --sass-dir "scss" --css-dir "css" --javascripts-dir "js" --images-dir "img"'
alias compass_sass='compass create --sass-dir "scss" --css-dir "css" --javascripts-dir "js" --images-dir "img" --syntax sass'

shrc_section_title "win like" #{{{2
alias rd=rmdir
#alias pulist='ps aux | grep '

pulist() { # {{{3
  local ARG i
  for i in $*; do
    if [ -z "$ARG" ]; then
      ARG=$i
    else
      ARG=$ARG"|"$i
    fi
  done
  if [ -z "$ARG" ]; then
    ps aux
  else
    ps aux | grep -E "PID|$ARG"
  fi
}

shrc_section_title "zsh" #{{{2
if [ -n "$ZSH_NAME" ]; then
  alias -g L="|& $PAGER"
  alias -g G='| grep -i'
  alias -g H='| head'
  alias -g T='| tail'
  alias -g V='| vim -'
  # alias -g V='| view -'
fi

shrc_section_title "some commands" #{{{1
alc() { #{{{2
  if [ $ != 0 ]; then
    w3m +38 "http://eow.alc.co.jp/$*/UTF-8/?ref=sa"
  else
    w3m "http://www.alc.co.jp/"
  fi
}

function gte() { #{{{2
  google_translate "$*" "en-ja"
}

function gtj() { #{{{2
  google_translate "$*" "ja-en"
}

function google_translate() { #{{{2
  local str opt cond

  if [ $# != 0 ]; then
    str=`echo $1 | sed -e 's/  */+/g'` # 1文字以上の半角空白を+に変換
    cond=$2
    if [ $cond = "ja-en" ]; then # ja -> en 翻訳
      opt='?hl=ja&sl=ja&tl=en&ie=UTF-8&oe=UTF-8'
    else # en -> ja 翻訳
      opt='?hl=ja&sl=en&tl=ja&ie=UTF-8&oe=UTF-8'
    fi
  else
    opt='?hl=ja&sl=en&tl=ja&ie=UTF-8&oe=UTF-8'
  fi

  opt="${opt}&text=${str}"
  w3m +13 "http://translate.google.com/${opt}"
}

shrc_section_title "GNU screen setting" #{{{1
if is_exec tscreen; then
  alias screen=tscreen
fi

shrc_section_title "ssh logging" #{{{1
if [ -z "$SSH_CLIENT" -a x$__ssh_path = x ]; then
  __ssh_path=$(which ssh)
  ssh() { # {{{2
    local SSH_LOG_DIR=$HOME/.ssh-logs
    [ ! -e $SSH_LOG_DIR ] && mkdir $SSH_LOG_DIR
    [ ! -e $SSH_LOG_DIR/org ] && mkdir -p $SSH_LOG_DIR/org

    if [ $(find $SSH_LOG_DIR -mtime +1 2>/dev/null | wc -l) -eq 1 ]; then
      ssh_logs_archive
    fi
    touch $SSH_LOG_DIR/.last_touch

    #_prefix=$(echo $* | perl -ne '$_=~s/\W+/_/g; print $_;')
    #_prefix=$(echo $* | perl -ne '$_=~s/(\d+\.\d+\.\d+\.\d+|[a-z\.-]+)/; print $1;')
    local _prefix=$(echo $* | perl -ne 'my @l;push @l,$1 while (/\s(\d+\.\d+\.\d+\.\d+|[a-z\.-]+)/g); print join("_",@l);')
    [ x$_prefix = x ] && _prefix=$(echo $* | perl -ne '$_=~s/\s+$//;$_=~s/\s+/_/g;$_=~s/([^\w ])/"%".unpack("H2", $1)/eg;print')
    local tmp_log_path=$SSH_LOG_DIR/org/$(date +'%Y%m%d_%H%M%S')_script_${_prefix}.log
    local log_path=$SSH_LOG_DIR/$(date +'%Y%m%d_%H%M%S')_script_${_prefix}.log

    $__ssh_path $* | tee $tmp_log_path
    if [ -s $tmp_log_path ] ; then
      cat $tmp_log_path | perl -ne '$_ =~ s/\e(\[\d*m?(;\d*m)?|\]\d*)//g; print $_' > $log_path
      #col -b $tmp_log_path > $log_path
    else
      rm -f $tmp_log_path
    fi
    #[ -e $tmp_log_path ] && rm -f $tmp_log_path
  }
# else
  # P_PROC=`ps aux | grep $PPID | grep sshd | awk '{ print $11 }'`
  # if [ "$P_PROC" = sshd: ]; then
    # script ~/log/`date +%Y%m%d-%H%M%S.log`
    # exit
  # fi
  ssh_logs_archive() { # {{{2
    local SSH_LOG_DIR=$HOME/.ssh-logs
    for f in $(find $SSH_LOG_DIR -depth 1 -type f -mtime +30); do
      local target=$SSH_LOG_DIR/$(stat -f %Sm -t %Y%m $f)
      [ ! -e $target ] && mkdir $target
      mv $f $target/
    done
  }
  # }}}
fi

# function ssh_screen(){
#   eval server=?${$#}
#   screen -t $server ssh "$@"
# }

# if [ x$TERM = xscreen ]; then
  # alias ssh=ssh_screen
# fi

# __END__ {{{1
# vim: fdm=marker sw=2 ts=2 ft=zsh et:
