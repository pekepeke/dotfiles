#!/bin/bash

mysqldump --opt --skip-lock-tables --default-character-set=binary --hex-blob {{_cursor_}} | gzip -c > tmp/dump_$(date +'%Y%m%d').sql.gz

