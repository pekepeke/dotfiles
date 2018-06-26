#!/bin/sh

if [ ! -e ~/.docker/config.json ] ; then
  cat <<EOM > ~/.docker/config.json
{
	"HttpHeaders": {},
	"__psFormat": "table {{.ID}}\\t{{.Image}}\\t{{.Command}}\\t{{.Labels}}",
	"__imagesFormat": "table {{.ID}}\\t{{.Repository}}\\t{{.Tag}}\\t{{.CreatedAt}}",
	"detachKeys": "ctrl-q,q"
}
EOM
fi
