#!/bin/bash

docker-compose-wrapper() {
  cat <<'EOM'
#!/bin/sh

docker run --rm -it -v $(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock dduportal/docker-compose "$@"

EOM
}



fig() {
  local dir=$(pwd)
  cat <<EOM
#!/bin/sh

boot2docker ssh -t 'cd $dir && ./docker-compose-wrapper' "\$@"

EOM
}

if [ -n "${WINDIR}" ]; then
  docker-compose-wrapper > docker-compose-wrapper
  chmod +x docker-compose-wrapper
  fig > fig
  chmod +x fig
fi

