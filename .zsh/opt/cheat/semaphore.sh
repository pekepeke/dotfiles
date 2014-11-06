# apache のセマフォを参照&開放
ipcs -s apache
ipcs -s | grep apache | perl -e 'while (<STDIN>) { @a=split(/\s+/);print `ipcrm sem $a[1]`}'

