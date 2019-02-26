#/bin/bash

# git://github.com/CHH/phpenv.git
# curl -L https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh | UPDATE=yes bash
cd ~/.phpenv
git pull
cd plugins/php-build
git pull
