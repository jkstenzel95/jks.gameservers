#!/bin/bash

subdomain=""
ip=""
while getopts s:i: flag
do
    case "${flag}" in
        s) subdomain=${OPTARG};;
        i) ip=${OPTARG};;
    esac
done

if [[ "${subdomain}" == "" ]]; then
    echo "Cannot create an alias record without a provided subdomain (-s)"
    exit 1
fi

if [[ "${ip}" == "" ]]; then
    echo "Cannot create an alias record without a provided IP (-i)"
    exit 1
fi

hosted_zone=$(aws route53 list-hosted-zones-by-name | jq ".HostedZones[] | select(.Name == \"${subdomain}.\") | .Id" | tr -d '/hostedzone/' | tr -d '"')
echo "{ \"Comment\": \"Create an alias to map ${subdomain} to ${ip}\", \"Changes\": [{ \"Action\": \"UPSERT\", \"ResourceRecordSet\": { \"Name\": \"${subdomain}\", \"Type\": \"A\", \"TTL\": 30, \"ResourceRecords\": [{ \"Value\": \"${ip}\"}]}}] }" > operation.json
aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone --change-batch "file://operation.json"
rm operation.json