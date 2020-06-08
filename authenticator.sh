#!/bin/bash

_dir="$(dirname "$0")"

source "$_dir/config.sh"

# Strip only the top domain to get the zone id
# DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
	
# Create TXT record
CREATE_DOMAIN="_acme-challenge"
RECORD_ID=$(curl -s -X POST "https://pddimp.yandex.ru/api2/admin/dns/add" \
     -H "PddToken: $API_KEY" \
     -d "domain=$CERTBOT_DOMAIN&type=TXT&content=$CERTBOT_VALIDATION&ttl=60&subdomain=$CREATE_DOMAIN" \
	 | python -c "import sys,json;print(json.load(sys.stdin)['record']['record_id'])")
	
if [ ! -d /tmp/CERTBOT_count ];then
        mkdir -m 0700 /tmp/CERTBOT_count
fi

COUNT_RECORD=0
if [ -f /tmp/CERTBOT_count/COUNT_RECORD ]; then
        COUNT_RECORD=$(cat /tmp/CERTBOT_count/COUNT_RECORD)
fi

# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi

echo $RECORD_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID_${COUNT_RECORD}
let "COUNT_RECORD += 1"
echo $COUNT_RECORD > /tmp/CERTBOT_count/COUNT_RECORD

# Sleep to make sure the change has time to propagate over to DNS
sleep 800
