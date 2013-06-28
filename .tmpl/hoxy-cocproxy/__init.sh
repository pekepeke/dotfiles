#!/bin/bash

hoxy_rule() {
  local cwd=$(pwd)
  cat <<'EOM'
# THIS IS AN EXAMPLE FILE THAT CONTAINS EXAMPLE RULES FOR HOXY.
# UNCOMMENT TO ACTIVATE. SEE readme.markdown IN THIS DIR FOR SYNTAX HELP.

# add a visible banner alerting user of proxy
#response: if $content-type contains 'html', @banner("currently browsing through a web hacking proxy")

# log every request to a given host
#response: if $hostname eq 'example.com', $url.log()

# use css and js from the staging server
#request: if $ext eq "js" and $host eq "www.example.com", $host.set-to('www-stage.example.com:83')
#request: if $ext eq "css" and $host eq "www.example.com", $host.set-to('www-stage.example.com:83')
EOM
  cat <<EOM
# request: if \$hostname eq 'xxx.jp', @ghost-server('${pwd}/files/')
request: @ghost-server('${pwd}/files/')
EOM
}


if [ ! -e hoxy-rules.txt ]; then
  hoxy_rule > hoxy-rules.txt
fi
