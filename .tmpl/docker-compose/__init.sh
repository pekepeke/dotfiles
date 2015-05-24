#!/bin/bash

compose() {
  cat <<'EOM'
#!/bin/sh

docker run --rm -it -v $(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock dduportal/docker-compose "$@"

EOM
}



compose_local() {
  local dir=$(pwd)
  cat <<EOM
#!/bin/sh

boot2docker ssh -t 'cd $dir && ./compose' "\$@"

EOM
}

if [ -n "$WINDIR" ]; then
  compose > compose
  chmod +x compose
  compose_local > compose_local
  chmod +x compose_local
fi

