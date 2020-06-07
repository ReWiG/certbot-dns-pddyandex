#!/bin/bash

_dir="$(dirname "$0")"

source "$_dir/config.sh"

# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
	
# Create TXT record
CREATE_DOMAIN="_acme-challenge"
RECORD_ID=$(curl -s -X POST "https://pddimp.yandex.ru/api2/admin/dns/add" \
     -H "PddToken: $API_KEY" \
     -d "domain=$CERTBOT_DOMAIN&type=TXT&content=$CERTBOT_VALIDATION&ttl=60&subdomain=$CREATE_DOMAIN" \
	 | python -c "import sys,json;print(json.load(sys.stdin)['record']['record_id'])")
	
if [ ! -d /tmp/CERTBOT_temp ];then
        mkdir -m 0700 /tmp/CERTBOT_temp
fi

COUNT_RECORD=1
if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/COUNT_RECORD ]; then
        COUNT_RECORD=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/COUNT_RECORD)
fi

# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi

echo $RECORD_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID_${COUNT_RECORD}
echo (($COUNT_RECORD+1)) > /tmp/CERTBOT_temp/COUNT_RECORD

# Sleep to make sure the change has time to propagate over to DNS

if [ "$COUNT_RECORD" -ne "1" ];then
	sleep 600
else
	sleep 5
fi
