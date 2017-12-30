#!/bin/sh

IP="192.168.8.1" #FIXME: Assuming hilink IP addres router and client is fixed
IP_CLIENT="192.168.8.100"

IFACE="enx0c5b8f279a64"
sudo dhclient -v $IFACE

if [ $(ifconfig  enx0c5b8f279a64 |grep "inet "| cut -c 14-27) = ${IP_CLIENT} ];
then
     echo "oh, hilink gave me an ip switch to debug mode ";
     cd /home/vagrant/
     dir="vagrant-huawei-lteusb-hilink"
     if [ -e $dir ]
     then
       echo "File $dir exists."
     else
       git config --global http.sslverify false #FIXME
       git clone https://jnunez:cc130382ae7be475d0aebf4656b3a954008b181d@pdihub.hi.inet/condor/vagrant-huawei-lteusb-hilink.git
     fi
     MODE=`lsusb -t | wc -l`
     if [ $MODE -eq 10 ]
     then
        echo "Debug mode already enabled."
     else
        echo "Setting debug mode."
        sh ./vagrant-huawei-lteusb-hilink/config/huawei_set_debug.sh $IP
     fi
     echo "deleting default route: default Internet through LTE." 
     sudo ip route del default via 10.0.2.2
fi                                                                                                                                           
