PUB_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
DOMAIN=mydomain.xxx
DOMAIN_IP="$(dig +short ${DOMAIN})"

if [ "$DOMAIN_IP" == "$PUB_IP" ]; then
        echo "IP is good!"
else
        API_KEY=<APIKEY>
        ZONE_ID=<ZONEID>
        DNS_ID=$(curl -X GET -H "Authorization: Bearer ${API_KEY}" "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?type=A&name=${DOMAIN}" 2>/dev/null | jq ".result[0].id" | sed "s/\"//g")
        curl -X PUT -H "Authorization: Bearer ${API_KEY}" -H "Content-Type: application/json" "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${DNS_ID}" -d "{\"type\":\"A\",\"name\":\"${DOMAIN}\",\"content\":\"${PUB_IP}\",\"ttl\":120,\"proxied\":false}"
fi

echo
