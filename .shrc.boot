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
  darwin*)
    export TMUX_DEFAULT_COMMAND="reattach-to-user-namespace -l $SHELL"
    export TMUX_PREFIX_COMMAND="reattach-to-user-namespace"
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
export EDITOR=vim
# stty
stty stop undef
stty werase undef

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
GREP_OPTIONS="--exclude-dir=.svn $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.git $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.hg $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.deps $GREP_OPTIONS"
GREP_OPTIONS="--exclude-dir=.libs $GREP_OPTIONS"

LS_OPTIONS="--show-control-chars"

if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
  # eval "`dircolors -b`"
  #alias dir='ls --color=auto --format=vertical'
  #alias vdir='ls --color=auto --format=long'

  export GREP_COLOR='1;37;41'
  #alias fgrep='fgrep --color=auto'
  #alias egrep='egrep --color=auto'
  GREP_OPTIONS="--color=auto $GREP_OPTIONS"

  [ -e ~/.dir_colors ] && eval `dircolors ~/.dir_colors -b`
  LS_OPTIONS="--color=auto $LS_OPTIONS"
fi
export GREP_OPTIONS
export LS_OPTIONS

shrc_section_title "aliases" #{{{1
shrc_section_title "notify" #{{{2
__NOTIFY() { # {{{3
  local title=$1
  shift

  if is_win ; then
    is_exec growlnotify && growlnotify -t $title -m "$*" --image ~/bin/data/growl_i.png
  elif is_mac ; then
    is_exec growlnotify && growlnotify -t $title -m "$*" --image ~/bin/data/growl_i.png
  else
    if is_exec growlnotify ; then
      growlnotify -t $title -m "$*" --image ~/bin/data/growl_i.png
    elif is_exec notify-send ; then
      notify-send $title "$*"
    fi
  fi
}

shrc_section_title "basic commands" #{{{2
alias ll='ls -l $LS_OPTIONS'
alias la='ls -A $LS_OPTIONS'
alias l='ls -CF $LS_OPTIONS'

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
if [ -x ~/bin/vimpager ] ; then
  export PAGER=~/bin/vimpager
  # alias less=$PAGER
  # alias zless=$PAGER
fi
alias vimfiler='vim -c VimFiler'
alias vimshell='vim -c VimShell'

alias viminspect='vim --startuptime "$HOME/vimrc-read.log"'
alias vimsafe='vim -u NONE -i NONE'
alias vimf='vim -u '
alias view='view -u $HOME/.vimpagerrc'

update-dotfiles-submodule() { #{{{3
  local cwd=$(pwd)
  cd ~/.github-dotfiles
  git submodule init
  git submodule foreach 'git checkout master; git pull origin master; git pull'
  if [ -e ~/.osx_library ]; then
    cd ~/.osx_library
    git submodule init
    git submodule foreach 'git checkout master; git pull origin master; git pull'
  fi
  cd ${cwd}
  __NOTIFY "update .github-dotfiles" "complete!"
}
vim-bundle() { #{{{3
  update-dotfiles-submodule
  find ~/.vim/neobundle -name tags | grep doc | grep -v .git | xargs rm
  vim -c "silent NeoBundleInstall" -c "silent NeoBundleInstall!" -c "quitall"
  __NOTIFY "neobundle update" "complete!"
}
# alias vim-bundle='update-submodules; vim -c "silent NeoBundleInstall" -c "silent NeoBundleInstall!" -c "silent VimprocCompile" -c "quitall";NOTIFY "neobundle update" "complete!"'

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
  # alias -g V='| vim -'
  alias -g V='| view -'
fi

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
