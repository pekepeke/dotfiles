# source local settings
# init {{{1
# [ $SHLVL -gt 1 ] && return 0
[ -f $HOME/.shrc.functions ] && source $HOME/.shrc.functions

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
        if [ "$(tmux display -p '#{window_name}')" = reattach-to-user-namespace ]; then
          tmux rename-window "$(pwd | perl -ne 's!'$HOME'!~!;print;')"
        fi
        # exec reattach-to-user-namespace -l $SHELL
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
EDITOR_VIM_MIN="vim -N -u ~/.vimrc.min"
# COL_CMD="col -bx"
# COL_CMD="sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g'"
COL_CMD="perl -ne 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g;print'"

export EDITOR="$EDITOR_VIM_MIN"
export RLWRAP_HOME=~/.rlwrap
# stty
if is_exec stty ; then
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
if is_mac ; then
  if is_exec gls; then
    alias ls="gls $LS_OPTIONS"
    alias ll="gls -l $LS_OPTIONS"
    alias la="gls -A $LS_OPTIONS"
    alias l="gls -CF $LS_OPTIONS"
  else
    alias ls="ls -GF"
    alias ll="ls -GFl"
    alias la="ls -GFA"
    alias l="ls -GCF"
  fi
else
  alias ls="ls $LS_OPTIONS"
  alias ll="ls -l $LS_OPTIONS"
  alias la="ls -A $LS_OPTIONS"
  alias l="ls -CF $LS_OPTIONS"
fi

alias grep="grep $GREP_OPTIONS"
unset GREP_OPTIONS
alias today='date +%Y%m%d'

alias ..='cd ..'

alias cp='cp -ip'
alias rm=' rm -i'
alias mv='mv -i'
alias sudo=' sudo -H'
alias telnet='telnet -K'
alias ack='ack-grep'
alias less='less -R'

alias gdiff='git diff --no-index --textconv --diff-algorithm=histogram'
alias cf='cheat-find'

if type rlwrap > /dev/null 2>&1; then
  alias cap='rlwrap cap'
fi

shrc_section_title "vim" #{{{2
if type lv > /dev/null 2>&1; then
  export PAGER=lv
  export LV="-c -l"
else
  [ -z "$PAGER" ] && export PAGER="less"
  # alias lv="$PAGER"
fi
# if [ -x ~/bin/vimpager ] ; then
#   export PAGER=~/bin/vimpager
#   # alias less=$PAGER
#   # alias zless=$PAGER
# fi
alias vimfiler="$EDITOR_VIM_MIN -c VimFiler"
alias vimshell="$EDITOR_VIM_MIN -c VimShell"
alias diary="$EDITOR_VIM_MIN ~/$(date +'%Y-%m-%d.md')"

alias vimrcinspect='vim --startuptime "$HOME/vimrc-read.txt" +q && vim ~/vimrc-read.txt'
alias gvimrcinspect='gvim --startuptime "$HOME/gvimrc-read.txt" && gvim --remote-silent ~/gvimrc-read.txt'
alias vimrcprofile='vim --cmd "profile start ~/vimrc-profile.txt" --cmd "profile file $HOME/.vimrc" +q && vim ~/vimrc-profile.txt'
alias vimrcprofileall='vim --cmd "profile start ~/vimrc-profileall.txt" --cmd "profile! file $HOME/.vimrc" +q && vim ~/vimrc-profileall.txt'
alias gvimrcprofile='gvim --cmd "profile start ~/gvimrc-profile.txt" --cmd "profile file $HOME/.vimrc" && gvim --remote-silent ~/gvimrc-profile.txt'
alias gvimrcprofileall='gvim --cmd "profile start ~/gvimrc-profileall.txt" --cmd "profile! file $HOME/.vimrc" && gvim --remote-silent ~/gvimrc-profileall.txt'
alias vimsafe='vim -u NONE -i NONE'
alias vimnone='vim -u NONE'
alias vimmin="$EDITOR_VIM_MIN"
alias vi="$EDITOR_VIM_MIN"
alias view='view -N -u ~/.vimrc.min'
alias ctags-php='ctags --append --langmap=PHP:+.inc -R --php-kinds=cfd --exclude="*.js"  --exclude=".git*"'
alias ctags-pl='ctags --append --langmap=perl:+.pm --exclude="*.js"  --exclude=".git*"'
alias ctags-py='ctags --append --langmap=python:+.pm --exclude="*.js"  --exclude=".git*"'
alias ctags-rb='ctags --append --langmap=RUBY:.rb --exclude="*.js"  --exclude=".git*"'
gvi () {
  if is_mac ;then
    command mvim --remote-silent "$@" || mvim "$@"
  else
    command gvim --remote-silent "$@" || gvim "$@"
  fi
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
alias ar='php `git rev-parse --show-toplevel`/artisan'
perlmodules() {
  cat `perldoc -l perllocal` | perl -nle '/C<Module> L<([^\|]*?)\|.*?>/ and print "$1"'
}

shrc_section_title "mysql" #{{{2
EXPLAIN_MYSQL() {
  mysql -e "SET NAMES utf8; EXPLAIN $*"
}
SELECT_MYSQL() {
  mysql -e "SET NAMES utf8; SELECT $*"
}
SHOW_MYSQL() {
  mysql -e "SET NAMES utf8; SHOW $*"
}
if [ -n "$ZSH_NAME" ]; then
  alias EXPLAIN='noglob EXPLAIN_MYSQL'
  alias SELECT='noglob SELECT_MYSQL'
  alias SHOW='noglob SHOW_MYSQL'
fi

shrc_section_title "etc" #{{{2
alias dm='docker-machine'
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

shrc_section_title "zsh" #{{{2
if [ -n "$ZSH_NAME" ]; then
  alias -g L="|& $PAGER"
  alias -g G="| grep -i"
  alias -g H=' $(git-hash-p)'
  alias -g F=' $(git-changed-files-p)'
  alias -g FA=' $(git-ls-files-p)'
  # alias -g V="| $EDITOR_VIM_MIN -"
  alias -g V="| $COL_CMD | $EDITOR_VIM_MIN -"
  alias -g P="| peco"
  alias -g PC="| peco | xargs echo -n | pbcopy-wrapper"
  alias -g J="| jq"
  # alias -g C="| col -bx | pbcopy-wrapper"
  alias -g C="| $COL_CMD | pbcopy-wrapper"
  # alias -g V="| view -"
  alias -g W=" 2>&1 | iconv -c -f Shift_JIS -t UTF-8"
fi

shrc_section_title "some commands" #{{{1
if [ "$SHELL" != "/bin/sh" ]; then
  source ~/.shrc.d/cdtask
fi

xdebugctl() {
  local REMOTE_HOST=$REMOTE_HOST
  if [ -z "$REMOTE_HOST" ]; then
    REMOTE_HOST=localhost
    [ -n "$SSH_CLIENT" ] && REMOTE_HOST=$(echo $SSH_CLIENT | awk '{print $1}')
  fi
  local idekey=
  case "$1" in
    phpstorm)
      export XDEBUG_CONFIG="remote_host=$REMOTE_HOST idekey=phpstorm remote_autostart=1"
      ;;
    netbeans)
      export XDEBUG_CONFIG="remote_host=$REMOTE_HOST idekey=netbeans-xdebug remote_autostart=1"
      ;;
    eclipse)
      export XDEBUG_CONFIG="remote_host=$REMOTE_HOST idekey=ECLIPSE_DBGP remote_autostart=1"
      ;;
    npp*)
      export XDEBUG_CONFIG="remote_host=$REMOTE_HOST idekey=npp-plus remote_autostart=1 remote_connect_back=1"
      ;;
    *)
      # unalias php
      export XDEBUG_CONFIG=""
      ;;
  esac
  echo XDEBUG_CONFIG=${XDEBUG_CONFIG}
}
# xdebugctl >/dev/null

sshp() {
  local SSH_HOST=$(cat ~/.ssh/config | awk '$1 == "Host" { print $2 }' | grep -v '*' | peco)
  local NEW_TERM=$TERM

  [ "$TERM" = "screen-256color" ] && NEW_TERM=xterm
  if [ -n "$SSH_HOST" ]; then
    PASS="$(getjsonval.py ~/.ssh/password.json $SSH_HOST)"
    if [ -n "$PASS" ]; then
      TERM=$NEW_TERM sshexp $PASS ssh $SSH_HOST
    else
      TERM=$NEW_TERM ssh $SSH_HOST
    fi
  fi
}

shrc_section_title "GNU screen setting" #{{{1
if is_exec tscreen; then
  alias screen=tscreen
fi

shrc_section_title "ssh logging" #{{{1
is_exec ssh-log && alias ssh='ssh-log'

# function ssh_screen(){
#   eval server=?${$#}
#   screen -t $server ssh "$@"
# }

# if [ x$TERM = xscreen ]; then
  # alias ssh=ssh_screen
# fi

shrc_section_title "source .local" #{{{1
if [ -f $HOME/.shrc.local ] ; then
  source $HOME/.shrc.local
else
  touch $HOME/.shrc.local
fi

# __END__ {{{1
# vim: fdm=marker sw=2 ts=2 ft=zsh et:
