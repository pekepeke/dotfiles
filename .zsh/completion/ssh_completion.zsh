create_ssh_hosts () {
  local t s
  t="$1"; shift

  [ -f $t ] || return 0

  for s; do
    [ $s -nt $t ] && return 0
  done

  return 1
}

if [ -e "$HOME/.tmp" ]; then
  cache_hosts_file="$HOME/.tmp/.cache_hosts"
else
  cache_hosts_file="$HOME/.cache_hosts"
fi
known_hosts_file="$HOME/.ssh/known_hosts"
ssh_config_file="$HOME/.ssh/config"

print_ssh_hosts () {
  if [ -f $known_hosts_file ]; then
    awk '{ if (split($1, a, ",") > 1) for (i in a) { if (a[i] ~ /^[a-z]/) print a[i] } else print $1 }' $known_hosts_file
  fi
  if [ -f $ssh_config_file ]; then
    grep -e '^Host' $ssh_config_file | awk '{print $2;}'
  fi
}

update_ssh_hosts () {
  print_ssh_hosts | sort -u > $cache_hosts_file
}

create_ssh_hosts $cache_hosts_file $known_hosts_file $ssh_config_file \
  && update_ssh_hosts

_cache_hosts=( $(< $cache_hosts_file) )
