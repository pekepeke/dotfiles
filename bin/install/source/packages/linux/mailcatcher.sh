#!/bin/bash

opt_uninstall=0
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

prefer-upstart() {
  [ -e /etc/init ]
  return $?
}

mailcatcher-bindir() {
  local BIN=$(dirname $(which mailcatcher))
  if which rbenv >/dev/null 2>&1; then
    local BIN=$(dirname $(rbenv which mailcatcher))
  fi
  echo $BIN
}

upstart-script() {
  local BIN=$(mailcatcher-bindir)
  cat <<'EOM'
description "mailcatcher"
author  "root <root@localhost>"

start on runlevel [2345]
stop on runlevel [016]

# chdir /usr/local/mailcatcher
exec $BIN/mailcatcher  >> /var/log/mailcatcher.log 2>&1
respawn
EOM
}

init-d-script() {
  local BIN=$(mailcatcher-bindir)

cat <<'EOM'
#! /bin/sh
### BEGIN INIT INFO
# Provides:          mailcatcher
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Example initscript
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.
### END INIT INFO

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
EOM
echo "PATH=/sbin:/usr/sbin:/bin:/usr/bin:$BIN"
cat <<'EOM'
DESC="Super simple SMTP server"
NAME=mailcatcher
EOM
echo "DAEMON=$BIN/$NAME"
cat <<'EOM'
DAEMON_ARGS=" --http-ip 0.0.0.0"
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

#
# Function that starts the daemon/service
#
do_start()
{
    # Return
    #   0 if daemon has been started
    #   1 if daemon was already running
    #   2 if daemon could not be started
    start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON --test > /dev/null \
        || return 1
    start-stop-daemon --start --quiet --pidfile $PIDFILE --exec $DAEMON -- \
        $DAEMON_ARGS \
        || return 2
    # Add code here, if necessary, that waits for the process to be ready
    # to handle requests from services started subsequently which depend
    # on this one.  As a last resort, sleep for some time.

    # Create the PIDFILE
    pidof mailcatcher >> $PIDFILE
}

#
# Function that stops the daemon/service
#
do_stop()
{
    # Return
    #   0 if daemon has been stopped
    #   1 if daemon was already stopped
    #   2 if daemon could not be stopped
    #   other if a failure occurred

    if [ -f "$PIDFILE" ]
    then
        kill `cat $PIDFILE`
        rm -f $PIDFILE
        return 0
    else
        return 1
    fi
}

#
# Function that sends a SIGHUP to the daemon/service
#
do_reload() {
    #
    # If the daemon can reload its configuration without
    # restarting (for example, when it is sent a SIGHUP),
    # then implement that here.
    #
    start-stop-daemon --stop --signal 1 --quiet --pidfile $PIDFILE --name $NAME
    return 0
}

case "$1" in
  start)
    [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
    do_start
    case "$?" in
        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
        2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
    esac
    ;;
  stop)
    [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
    do_stop
    case "$?" in
        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
        2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
    esac
    ;;
  status)
    status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
    ;;
  #reload|force-reload)
    #
    # If do_reload() is not implemented then leave this commented out
    # and leave 'force-reload' as an alias for 'restart'.
    #
    #log_daemon_msg "Reloading $DESC" "$NAME"
    #do_reload
    #log_end_msg $?
    #;;
  restart|force-reload)
    #
    # If the "reload" option is implemented then remove the
    # 'force-reload' alias
    #
    log_daemon_msg "Restarting $DESC" "$NAME"
    do_stop
    case "$?" in
      0|1)
        do_start
        case "$?" in
            0) log_end_msg 0 ;;
            1) log_end_msg 1 ;; # Old process is still running
            *) log_end_msg 1 ;; # Failed to start
        esac
        ;;
      *)
        # Failed to stop
        log_end_msg 1
        ;;
    esac
    ;;
  *)
    #echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
    echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" >&2
    exit 3
    ;;
esac
EOM
}

install() {
  if prefer-upstart; then
    upstart-script >/etc/init/mailcatcher.conf
    initctl reload-configuration
    initctl start mailcatcher
  else
    init-d-script > /etc/init.d/mailcatcher
    chmod +x /etc/init.d/mailcatcher
    if which update-rc.d >/dev/null 2>&1; then
      update-rc.d mailcatcher defaults
    else
      chkconfig --add mailcatcher
    fi
    /etc/init.d/mailcatcher start
  fi
}

uninstall() {
  if prefer-upstart; then
    if initctl stop mailcatcher; then
      rm /etc/init/mailcatcher.conf
      initctl reload-configuration
    fi
  else
    if /etc/init.d/mailcatcher stop; then
      if which update-rc.d >/dev/null 2>&1; then
        update-rc.d -f mailcatcher remove
      else
        chkconfig --del mailcatcher
      fi
    fi
  fi
}

main() {
  if [ "$opt_uninstall" = 1 ]; then
    uninstall
  else
    install
  fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvu" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
    u)
      opt_uninstall=1
      #$OPTARG
      ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

