
SYNCROOT=~/projects-html/xxx
DSTROOT=$(cd `dirname $0`; pwd)/path/to
# OPTS=""
OPTS="--dry-run"

rsync -av $OPTS $SYNCROOT/css/ $DSTROOT/css/
rsync -av $OPTS $SYNCROOT/js/ $DSTROOT/js/
# rsync -av $OPTS $SYNCROOT/img/ $DSTROOT/img/
rsync -av $OPTS --delete --exclude fuga/ --exclude *.tiff $SYNCROOT/img/ $DSTROOT/img/

