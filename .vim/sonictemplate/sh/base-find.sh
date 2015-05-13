#!/bin/bash

APP_ROOT="."
SEARCH_DIR="${APP_ROOT}"
OPTIONS=" --ignore-dir ${APP_ROOT}/plugin --ignore-dir ${APP_ROOT}/tmp --ignore-dir ${APP_ROOT}/public"
case "$1" in
  c)
    SEARCH_DIR="${SEARCH_DIR}/controller"
    shift
    ;;
  m)
    SEARCH_DIR="${SEARCH_DIR}/model"
    shift
    ;;
  v)
    SEARCH_DIR="${SEARCH_DIR}/view"
    shift
    ;;
  l)
    SEARCH_DIR="${SEARCH_DIR}/lib"
    shift
    ;;
esac

ag -i ${OPTIONS} "$*" "${SEARCH_DIR}"

