#use to retrive information from dongle
# call with ./huawe_set_debug.sh <IP> 

#!/bin/sh


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



resetMode()
{
	        echo "$(curl -s -H "Content-Type: application/xml" -H "__RequestVerificationToken: $token" -H "Cookie: $sessionID" -X POST -d "<?xml version='1.0' encoding='UTF-8' ?><request><mode>1</mode></request>" http://$IP/api/device/mode)"
}


getTokenAndSessionID

echo "token is $token"
echo "session is $sessionID"
echo "sent $2 to $IP"
  echo ""

resetMode 
