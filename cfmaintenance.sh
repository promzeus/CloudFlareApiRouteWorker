#!/bin/bash

set -e
set -u

up() {
    for i in "${!zoneid[@]}"; do
        echo route_pattern: "maintenanceoff.${i}/*"
        zone_id=$(echo ${zoneid[$i]} | awk -F: '{print $1}')
        route_id=$(echo ${zoneid[$i]} | awk -F: '{print $2}')
        echo route_id: $route_id
        echo zone_id: $zone_id
        curl -X PUT "https://api.cloudflare.com/client/v4/zones/"${zone_id}"/workers/routes/"${route_id}"" \
        -H "Authorization: Bearer ${bearer_token}" \
        -H "Content-Type: application/json" \
        --data '{"pattern":"'"maintenanceoff.${i}/*"'","script":"'"${worker}"'"}'
    done
}

down() {
    for i in "${!zoneid[@]}"; do
        echo route_pattern: "${i}/*"
        zone_id=$(echo ${zoneid[$i]} | awk -F: '{print $1}')
        route_id=$(echo ${zoneid[$i]} | awk -F: '{print $2}')
        echo route_id: $route_id
        echo zone_id: $zone_id
        curl -X PUT "https://api.cloudflare.com/client/v4/zones/"${zone_id}"/workers/routes/"${route_id}"" \
        -H "Authorization: Bearer ${bearer_token}" \
        -H "Content-Type: application/json" \
        --data '{"pattern":"'"${i}/*"'","script":"'"${worker}"'"}'
    done
}

bearer_token="create bearer token access in api CF"

#worker name
worker="maintenance"

#GET route_id: curl -X GET "https://api.cloudflare.com/client/v4/zones/${zoneid}/workers/routes/" -H "X-Auth-Email: email@domain.com" -H "X-Auth-Key: ${apikey}"
#Declare ===>>>> domain_route_pattern=zone_id:route_id <<<<===
declare -A zoneid
zoneid[domain1.com]="abcd:bcde"
zoneid[domain2.com]="zxcv:bnmj"
...
...
zoneid[domain2248.com]="qwerty:ytrewq"

if [ $# -eq 0 ]
then
echo "Use: up or down"
exit 1
fi
    case $1 in
        "up")
        up
            ;;
        "down")
        down
            ;;
        *) echo "invalid option";;
    esac
