#!/bin/bash

if [ ! -e ~/.composer/vendor/bin/composer ] ; then
  curl -sS https://getcomposer.org/installer | php
  mkdir -p ~/.composer/vendor/bin/
  mv composer.phar ~/.composer/vendor/bin/composer
fi
