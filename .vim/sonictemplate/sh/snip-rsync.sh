
PROJROOT=~/projects-html/soniaca
STATICROOT=$(dirname $0; pwd)
OPTS="--dry-run"

rsync -av $OPTS $PROJROOT/css/ $STATICROOT/css/
rsync -av $OPTS $PROJROOT/js/ $STATICROOT/js/
rsync -av $OPTS --delete --exclude fuga/ --exclude *.tiff $PROJROOT/img/ $STATICROOT/img/

