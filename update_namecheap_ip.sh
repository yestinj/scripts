#!/bin/bash

DYNAMIC_HOST='<fill in>'
DOMAIN='<fill in>'
PASSWORD='<fill in>'

echo "Detecting IP address..."
MY_IP=$(curl -s ipinfo.io/ip)
echo "Updating IP to ${MY_IP}"
curl https://dynamicdns.park-your-domain.com/update\?host\=${DYNAMIC_HOST}\&domain\=${DOMAIN}\&password\=${PASSWORD}\&ip\=${MY_IP}
echo "Done!"
