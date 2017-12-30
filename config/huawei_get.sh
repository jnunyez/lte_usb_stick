#use to retrive information from dongle
# call with ./huawei_get <IP> <API-path>

#!/bin/sh
# URIs used to retrieve hilink information
#/api/monitoring/traffic-statistics
#/api/device/signal
#/api/device/mode
#/api/device/information
#/api/security/dmz


#globals for token, cookie, IP-Address, and api request
token=''
sessionID=''
IP=$1
path=$2


extractVal()
{
          regExp='s#.*<'$2'>\(.*\)</'$2'>.*#\1#p'
          echo $(echo "${1}" | sed -n -e "$regExp")
}
    #first thing ever to do, get sessionID and cookie,
    #save them in global var
getTokenAndSessionID()
{
        payload=$(curl -s -H "Content-Type: text/xml" -X GET http://$IP/api/webserver/SesTokInfo)
        sessionID=$(extractVal "$payload" "SesInfo")
        token=$(extractVal "$payload" "TokInfo")
}




sendQuery()
    {
          echo "$(curl -s -H "Content-Type: application/xml" -H "__RequestVerificationToken: $token" -H "Cookie: $sessionID" -X GET http://${IP}${1})"
      }

getTokenAndSessionID

echo "token is $token"
echo "session is $sessionID"
echo "sent $2 to $IP"
  echo ""
sendQuery $path
