#!/bin/bash

cd "$(dirname $0)"
CURDIR=$(pwd)
ROOT=$(dirname $CURDIR)

# REPOSITORY="fuga-$(basename $CURDIR)"
[ -z "$IMAGE_NAME" ] && IMAGE_NAME=$(basename $CURDIR)
[ -z "$TAG" ] && TAG=latest

for f in dockerenv dockerenv.local ; do
  [ -e ../$f ] && . ../$f
  [ -e ./$f ] && . ./$f
done

# while true ; do
CMD="docker"
ACTION="$1"
case "$1" in
  -d|--dry-run)
    shift
    CMD="echo docker"
    echo "pwd: $(pwd)"
    ACTION="$1"
    shift
    ;;
  -*)
    ACTION=build
    ;;
  *)
    ACTION="$1"
    shift
esac
[ -z "$ACTION" ] && ACTION=build

case $ACTION in
  run)
    echo $CMD run "$@" ${RUN_OPTIONS} $IMAGE_NAME:$TAG
    $CMD run "$@" ${RUN_OPTIONS} $IMAGE_NAME:$TAG
    ret=$?
    [ $ret -ne 0 ] && exit $ret
    ;;
  tag)
    [ -z "$REGISTRY" ] && echo "error: registry not found" >&2 && exit 1
    echo $CMD tag "$@" $IMAGE_NAME:$TAG $REGISTRY/$REPOSITORY:$TAG
    $CMD tag "$@" $IMAGE_NAME:$TAG $REGISTRY/$REPOSITORY:$TAG
    ret=$?
    $CMD images | grep "$REGISTRY/$REPOSITORY"
    [ $ret -ne 0 ] && exit $ret
    ;;
  push)
    [ -z "$REGISTRY" ] && echo "error: registry not found" >&2 && exit 1
    $CMD push "$@" $REGISTRY/$REPOSITORY:$TAG
    ret=$?
    [ $ret -ne 0 ] && exit $ret
    ;;
  build)
    echo $CMD build $BUILD_ARGS "$@" -t $IMAGE_NAME:$TAG .
    $CMD build $BUILD_ARGS "$@" -t $IMAGE_NAME:$TAG .
    ret=$?
    [ $ret -ne 0 ] && exit $ret
    ;;
  *)
    echo "invalid arguments: $ACTION $*" 1>&2
    exit 1
esac

# if [ -z "$1" ]; then
#   break
# fi
# done

exit 0

