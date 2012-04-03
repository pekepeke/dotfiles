# source local settings
# [ $SHLVL -gt 1 ] && return 0
[ -f $HOME/.shrc.functions ] && source $HOME/.shrc.functions

if [ -f $HOME/.shrc.local ] ; then
  source $HOME/.shrc.local
else
  touch $HOME/.shrc.local
fi
# }}}
# {{{ terminal
if is_exec reattach-to-user-namespace ; then
  export TMUX_DEFAULT_COMMAND="reattach-to-user-namespace -l $SHELL"
  export TMUX_PREFIX_COMMAND="reattach-to-user-namespace"
else
  export TMUX_DEFAULT_COMMAND=$SHELL
fi

if is_mac ; then
  export LESS="-IMR"
fi
if is_colinux; then
  alias umount-c='sudo umount /c'
  alias mount-c='mount-c-smbfs'
  alias mount-c-cofs='sudo mount -t cofs cofs0 /c -o defaults,noatime,noexec,user,uid=$USER,gid=users'
  alias mount-c-smbfs='sudo mount -t smbfs "//windows/C\$" /c -o defaults,noatime,user,uid=$USER,gid=users,fmask=0644,dmask=0755,username=$USER'
  alias shutdown-colinux='sudo halt; exit'
fi
# }}}

# {{{ lang, own settings
if is_exec vim ; then
  export EDITOR="$(which vim)"
else
  export EDITOR="$(which vi)"
fi

# stty
stty stop undef
stty werase undef

if [ ! -e "$TERMINFO" -a -e "/usr/share/terminfo" ]; then
  export TERMINFO=/usr/share/terminfo
fi

# for mysql
#export MYSQL_PS1='[1;33m\u@\h[0m.[1;35m\d[0m mysql:\c> '
export MYSQL_PS1='\u@\h.\d mysql:\c> '

# }}}

# {{{ color
# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  #alias dir='ls --color=auto --format=vertical'
  #alias vdir='ls --color=auto --format=long'

  export GREP_COLOR='1;37;41'
  #alias grep='grep -E --color=auto'
  alias grep='grep --color=auto'
  #alias fgrep='fgrep --color=auto'
  #alias egrep='egrep --color=auto'
fi

# }}}

# {{{ aliases
__NOTIFY() {
  local title=$1
  shift

  if is_win ; then
    is_exec growlnotify && growlnotify -t $title -m "$*"
  elif is_mac ; then
    is_exec growlnotify && growlnotify -t $title -m "$*"
  else
    if is_exec growlnotify ; then
      growlnotify -t $title -m "$*"
    elif is_exec notify-send ; then
      notify-send $title "$*"
    fi
  fi
}
if is_exec gls ; then
  alias ls='gls --color=auto'
else
  alias ls='ls --color=auto'
fi

#alias ls='ls -hF --show-control-chars --color'
#alias ls='ls --show-control-chars --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto'
alias today='date +%Y%m%d'

alias ..='cd ..'

alias cp='cp -ip'
alias rm=' rm -i'
alias mv='mv -i'
alias sudo=' sudo -H'
alias telnet='telnet -K'

# vim
alias vimfiler='vim -c VimFiler'
alias vimshell='vim -c VimShell'
update-submodules() {
  local cwd=$(pwd)
  cd ~/.github-dotfiles
  git submodule init
  git submodule foreach 'git fetch; git checkout origin/master'
  cd ${cwd}
  __NOTIFY "update .github-dotfiles" "complete!"
}
vim-bundle() {
  update-submodules
  vim -c "silent NeoBundleInstall" -c "silent NeoBundleInstall!" -c "silent VimprocCompile" -c "quitall"
  __NOTIFY "neobundle update" "complete!"
}
# alias vim-bundle='update-submodules; vim -c "silent NeoBundleInstall" -c "silent NeoBundleInstall!" -c "silent VimprocCompile" -c "quitall";NOTIFY "neobundle update" "complete!"'

# emacs
## Invoke the ``dired'' of current working directory in Emacs buffer.
function dired () {
  emacsclient -e "(dired \"${1:a}\")"
}

## Chdir to the ``default-directory'' of currently opened in Emacs buffer.
cde() {
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

# lang
alias iperl='perl -de0'
alias rol='ruby -n -e '

# rsync 
alias rsync='rsync -avzu'

# display charset
alias utf8='export LANG=ja_JP.UTF-8; export LANGUAGE=ja_JP.UTF-8; export LC_ALL=ja_JP.UTF-8'
alias euc='export LANG=ja_JP.EUC; export LANGUAGE=ja_JP.EUC; export LC_ALL=ja_JP.EUC'
alias en='export LANG=en; export LANGUAGE=en; export LC_ALL=en'

alias viminspect='vim --startuptime "$HOME/vimrc-read.log"'
alias vimsafe='vim -u NONE -i NONE'
alias vimf='vim -u '

# compass
alias compass_scss='compass create --sass-dir "scss" --css-dir "css" --javascripts-dir "js" --images-dir "img"'
alias compass_sass='compass create --sass-dir "scss" --css-dir "css" --javascripts-dir "js" --images-dir "img" --syntax sass'

# win like
alias rd=rmdir
#alias pulist='ps aux | grep '

pulist() { # {{{
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
} # }}}

if [ -z "$SSH_CLIENT" -a x$__ssh_path = x ]; then
  __ssh_path=$(which ssh)
  ssh() {
    local _ssh_log_dir=$HOME/.ssh-logs
    if [ ! -e $_ssh_log_dir ]; then
      mkdir $_ssh_log_dir
      mkdir $_ssh_log_dir/org
    fi
    #_prefix=$(echo $* | perl -ne '$_=~s/\W+/_/g; print $_;')
    #_prefix=$(echo $* | perl -ne '$_=~s/(\d+\.\d+\.\d+\.\d+|[a-z\.-]+)/; print $1;')
    local _prefix=$(echo $* | perl -ne 'my @l;push @l,$1 while (/\s(\d+\.\d+\.\d+\.\d+|[a-z\.-]+)/g); print join("_",@l);')
    [ x$_prefix = x ] && _prefix=$(echo $* | perl -ne '$_=~s/\s+$//;$_=~s/\s+/_/g;$_=~s/([^\w ])/"%".unpack("H2", $1)/eg;print')
    local tmp_log_path=$_ssh_log_dir/org/$(date +'%Y%m%d_%H%M%S')_script_${_prefix}.log
    local log_path=$_ssh_log_dir/$(date +'%Y%m%d_%H%M%S')_script_${_prefix}.log

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
  function ssh_logs_archive() {
    local _ssh_log_dir=$HOME/.ssh-logs
    for f in $(find $_ssh_log_dir -depth 1 -type f -mtime +30); do
      local target=$_ssh_log_dir/$(stat -f %Sm -t %Y%m $f)
      [ ! -e $target ] && mkdir $target
      mv $f $target/
    done
  }
fi

if [ -n "$ZSH_NAME" ]; then
  alias -g L='| less'
  alias -g H='| head'
  alias -g T='| tail'
  alias -g V="| vim -"
fi
# }}}

# tmux {{{
if [ "$TMUX" != "" ]; then
  tmux set-option status-bg colour$(($(echo -n $(whoami)@$(hostname) | sum | cut -f1 -d' ') % 8 + 8)) | cat > /dev/null
fi

# }}}
# GNU screen setting {{{
if is_exec tscreen; then
  alias screen=tscreen
fi

# function ssh_screen(){
  # eval server=?${$#}
  # screen -t $server ssh "$@"
# }

# if [ x$TERM = xscreen ]; then
  # alias ssh=ssh_screen
# fi
# }}}

# vim: fdm=marker sw=2 ts=2 ft=zsh et: