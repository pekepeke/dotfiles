SITE=http://www.oracle.com
URL=${SITE}$(curl -s $SITE/technetwork/java/javase/downloads/index.html | egrep -o "/technetwork/java/javase/downloads/jdk[0-9]{1,2}-downloads-[0-9]+\.html" | head -1)
DOWNLOAD_URL=$(curl -s "$URL" | egrep -o "http://download\.oracle\.com/otn-pub/java/jdk/.*x64_bin\.rpm")
FNAME=$(basename $DOWNLOAD_URL)
wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $DOWNLOAD_URL -O $FNAME
