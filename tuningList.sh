#!/bin/bash
executeable="~/tuning.sh -i ${serviceID} -d ${numberofDays}d"

echo -n "Please enter the customer id."
read customerID
echo ${customerID}
fastlycli c ${customerID}

curl -g -H "Fastly-Key: $Fastly_Token" "https://api.fastly.com/wafs?filter[customer_id]=5gmn89OSsx22lk5DxCix89" | jq '.data | .[] | .attributes | .service_id'

echo -n "Which service are you looking to create a report for?"
read serviceID
echo ${serviceID}

echo -n "For how many days should we fetch data?"
read numberofDays
echo ${numberofDays}

echo  ~/tuning.sh -i ${serviceID} -d ${numberofDays}d
bash ~/tuning.sh -i ${serviceID} -d ${numberofDays}d


#endpoint to list out WAF services
#curl -g -H "Fastly-Key: $Fastly_Token" "https://api.fastly.com/wafs?filter[customer_id]=5gmn89OSsx22lk5DxCix89" | jq '.data | .[] | .attributes | .service_id'
