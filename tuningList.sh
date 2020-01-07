#!/bin/bash
executeable="~/tuning.sh -i ${serviceID} -d ${numberofDays}d"

echo -n "Please enter the customer id."
read customerID
echo ${customerID}

#Services with WAF for a customer.

serviceIDs=$(curl -g -H "Fastly-Key: $Fastly_Token" "https://api.fastly.com/wafs?filter[customer_id]=${customerID}" | jq -r '.data | .[] | .attributes | .service_id')

echo $serviceIDs

#IFS=$'ln'
for serviceID in $serviceIDs; do
  echo $serviceID
  fastlycli s ${serviceID}
done

exit

echo -n "Which service are you looking to create a report for?"
read serviceID
echo ${serviceID}

echo -n "For how many days should we fetch data?"
read numberofDays
echo ${numberofDays}

echo  ~/tuning.sh -i ${serviceID} -d ${numberofDays}d
bash ~/tuning.sh -i ${serviceID} -d ${numberofDays}d
