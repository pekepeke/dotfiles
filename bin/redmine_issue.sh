#!/bin/sh
# original : https://github.com/akiko-pusu/misc/blob/master/misc/redmine_postIssue.sh
#
#-----------------------------------------------------------------------------
# RedmineのREST APIを利用して、curlを経由してチケットを作成するためのShell scriptです。
# Perlとcurlが利用できることが前提済みです。
#
# Redmineの認証用に、API Keyを必要とします。
# Keyに関しては、下記を参照して下さい。
#
# http://www.r-labs.org/projects/r-labs/wiki/Redmine_REST_API
#
#-----------------------------------------------------------------------------

USAGE="usage: $0 [-u|--url redmine_url] [-k|--key api_key] [-p|--project_id project_id] [-t|--tracker_id tracker_id] [-s|--subject \"issue subject\"] [-d|--description \"issue description\"]"


if [ $# -lt 6 ]; then
  echo >&2 $USAGE
  exit 1
fi

OPT=`getopt -o u:k:p:t:s:d: -l url:,key:,project_id:,tracker_id:,subject:,description: -- $*`
if [ $? != 0 ]; then
  echo >&2 $USAGE
  exit 1
fi
eval set -- $OPT
while [ -n "$1" ]; do
  case $1 in
    -u|--url) REDMINE_URL=$2 ; shift 2;;
    -k|--key) API_KEY=$2 ; shift 2;;
    -p|--project_id) PROJECT_ID=$2 ; shift 2;;
    -t|--tracker_id) TRACKER_ID=$2 ; shift 2;;
    -s|--subject) SUBJECT=$2 ; shift 2;;
    -d|--description) DESCRIPTION=$2 ; shift 2;;
    --) shift; break;;
    *) echo "Unknown option($1) used."; exit 1;;
  esac
done

if [ -z "$REDMINE_URL" ]; then
  echo >&2 $USAGE
  exit 1
fi

if [ -z "$API_KEY" ]; then
  echo >&2 $USAGE
  exit 1
fi

if [ -z "$PROJECT_ID" ]; then
  echo >&2 $USAGE
  exit 1
fi

if [ -z "$TRACKER_ID" ]; then
  echo >&2 $USAGE
  exit 1
fi

if [ -z "$SUBJECT" ]; then
  echo >&2 $USAGE
  exit 1
fi

if [ -z "$DESCRIPTION" ]; then
  echo >&2 $USAGE
  exit 1
fi


OUTFILE=$(mktemp -t redmine_postIssue.XXXXXXXX)
echo "Temp file is:     $OUTFILE" >> $OUTFILE
echo "API Key is:     $API_KEY" >> $OUTFILE
echo "Redmine project name:  $PROJECT_ID" >> $OUTFILE
echo "Tracker id:  $TRACKER_ID" >> $OUTFILE
echo "Subject: $SUBJECT" >> $OUTFILE
echo "Description: $DESCRIPTION" >> $OUTFILE
echo "" >> $OUTFILE


CURLTEMP=$(mktemp -t redmine_postIssue_curl.XXXXXXXX)

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" >> $CURLTEMP
echo "<issue>" >> $CURLTEMP
echo "<project_id>${PROJECT_ID}</project_id>" >> $CURLTEMP
echo "<tracker_id>${TRACKER_ID}</tracker_id>" >> $CURLTEMP
echo "<subject>${SUBJECT}</subject>" >> $CURLTEMP
echo "<description>${DESCRIPTION}</description>" >> $CURLTEMP
echo "</issue>" >> $CURLTEMP

curl -o result.xml -s -H "Content-type: text/xml" -X POST -d "@${CURLTEMP}" "${REDMINE_URL}/issues.xml?key=${API_KEY} > result"
ISSUE_ID=`perl -ne 'if(/<issue><id>([0-9]+)<\/id>/) { print $1; } ' result.xml`

if [ -z "$ISSUE_ID" ]; then
  echo >&2 "Issue creation task was failed. Please refere Redmine's log file."
  exit 1
fi

echo "Issue Created / #$ISSUE_ID"
echo "Issue URL / $REDMINE_URL/issues/$ISSUE_ID"

### Clean up our temp files and we're done.

rm result.xml
rm $CURLTEMP
rm $OUTFILE

