#!/bin/bash

_dir="$(dirname "$0")"

source "$_dir/config.sh"

if [ -f /tmp/CERTBOT_count/COUNT_RECORD ]; then
        COUNT_RECORD=$(cat /tmp/CERTBOT_count/COUNT_RECORD)
fi

let "COUNT_RECORD -= 1"

if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID_${COUNT_RECORD} ]; then
        RECORD_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID_${COUNT_RECORD})
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID_${COUNT_RECORD}
fi

# Remove the challenge TXT record from the zone
if [ -n "${RECORD_ID}" ]; then
	
	RESULT=$(curl -s -X POST "https://pddimp.yandex.ru/api2/admin/dns/del" \
     -H "PddToken: $API_KEY" \
     -d "domain=$CERTBOT_DOMAIN&record_id=$RECORD_ID" \
	 | python -c "import sys,json;print(json.load(sys.stdin)['success'])")
	
	echo $RESULT 
fi

if [ "$COUNT_RECORD" -eq "0" ];then
	rm -rf /tmp/CERTBOT_count/
fi
