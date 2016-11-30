#!/bin/sh

cat <<EOM
Add following codes to composer.json

        "phpunit/phpunit": "4.0.*",
        "theseer/phpdox": "*",
        "squizlabs/php_codesniffer": "*",
        "phpmd/phpmd": "*",
        "h4cc/phpqatools": "*",
        "phploc/phploc": "*",
        "sebastian/phpcpd": "*",
        "phpdocumentor/phpdocumentor": "*",
        "mayflower/php-codebrowser": "*",
        "phing/phing": "*"

If you want to replace src folder, you type following commands.

  $ sed -i -e 's!/src!/path/to/src!g' *.xml
  $ sed -i -e 's!Example!ProjName!g' *.xml
  $ sed -i -e 's!My Project!ProjName!g' *.xml

EOM
