#!/bin/bash
IFS=$'\n'
source secrets.txt
source options.txt

# list of e-mails
file=input.txt

# create array of e-mails
lines=$(cat ${file})

# loop through each e-mail and get current tags

for line in ${lines}; do
   #store id and tags separately
   id=$(echo "${line}" | cut -f1 -d ",")
   tag=$(echo "${line}" | cut -f2- -d ",")

   # If current tag is empty/null, add new tag
   if [[ -z "${tag// }" ]]; then
      curl -X $METHOD -H 'Content-Type: application/json' --retry 5 https://$API_KEY:$API_SECRET@$STORE_NAME.myshopify.com/admin/api/$API_VERSION/$RESOURCE/${id}.json \
      -d '{"customer": {"id": '${id}', "tag_string": "'${NEWTAG}'"}}'
   #Otherwise append new tag
   else
      curl -X $METHOD -H 'Content-Type: application/json' --retry 5 https://$API_KEY:$API_SECRET@$STORE_NAME.myshopify.com/admin/api/$API_VERSION/$RESOURCE/${id}.json \
      -d '{"customer": {"id": '${id}', "tag_string": "'${tag}','${NEWTAG}'"}}'
   fi

done

IFS=""
exit ${?}
