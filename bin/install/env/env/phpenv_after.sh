#!/bin/bash

[ ! -e plugins/php-build/share/php-build/after-install.d/ ] && exit 1

cd plugins/php-build/share/php-build/after-install.d/
curl -Lo composer "https://raw.github.com/rogeriopradoj/php-build-plugin-composer/master/share/php-build/after-install.d/composer.sh"
chmod +x composer
echo "Finish : composer installed"
