_to=""
_from=""
_subject=""
_body=""

/usr/sbin/sendmail -t << EOF
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
From: ${_from}
To: ${_to}
Subject: ${_title}
${_body}

EOF
