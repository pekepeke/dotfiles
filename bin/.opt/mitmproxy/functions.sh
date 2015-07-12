mitmproxy_usage() {
  local prog=$(basename $0)
  cat <<EOM
  usage: $prog [-hP]

Options:
  -h      show this message and exit.
  -P      exec with mitmproxy

EOM
}
exec_mitmproxy() {

  local opt_interactive=0
  local opt_help=0
  local args=""

  local options="${options} -s $scriptdir/.opt/mitmproxy/inject_weinre.py"
  options="${options} -s $scriptdir/.opt/mitmproxy/autoauth.py"
  options="$options -s $scriptdir/.opt/mitmproxy/replace_host.py"
  for opt in $@; do
    if [ "$opt" == "--interactive" ]; then
      opt_interactive=1
    elif [ "$opt" == "-P" ]; then
      opt_interactive=1
    elif [ "$opt" == "-help" -o "$opt" == "-h" ]; then
      mitmproxy_usage
      opt_help=1
      args="$args $opt"
    else
      args="$args $opt"
    fi
  done
  if [ $opt_interactive -eq 1 ]; then
    [ $opt_help -eq 0 ] && echo "execute : mitmproxy $options $args"
    exec mitmproxy $options $args
  else
    [ $opt_help -eq 0 ] && echo "execute : mitmdump $options $args"
    exec mitmdump $options $args
  fi

}
