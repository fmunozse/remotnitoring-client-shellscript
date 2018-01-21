#!/bin/sh

#set -x
user=admin
pwd=admin

url=http://remotnitoring:80
pause=300


url_auth=${url}/api/authenticate
url_ping=${url}/api/monitor/heartbeats/ping

HEADER="--header 'Content-Type: application/json' --header 'Accept: application/json' "
JSON="{\"password\": \"${pwd}\",  \"rememberMe\": true,  \"username\": \"${user}\"}"
PYTHON=" python -c \"import json,sys;obj=json.load(sys.stdin);print obj['id_token'];\" " 

while :
do
  cmd_auth="curl i -s -X POST $HEADER -d '$JSON' '${url_auth}' | $PYTHON "
  eval VAR=\$\($cmd_auth\)

  echo idToken=$VAR 

  HEADER_SECURE="$HEADER --header 'Authorization: Bearer $VAR' "

  cmd_ping="curl  -i  -X POST $HEADER_SECURE '${url_ping}'  "
  eval $cmd_ping
  

  sleep $pause

done
