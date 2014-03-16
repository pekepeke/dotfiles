#!/bin/bash

require="Web.HTML Web.HTTP Web.JSON Web.XML Vim.Buffer Vim.BufferManager Vim.Message OptionParser "

vitalize() {
  cwd=$(pwd)
  scriptdir=$(cd $(dirname $0); pwd)
  vim -c "Vitalize ${scriptdir} ${require}"
}

vitalize
