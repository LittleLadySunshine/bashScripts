# url encode all special characters
rawurlencode() {
  while IFS="" read -r string; do
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
       c=${string:$pos:1}
       case "$c" in
          [-_.~a-zA-Z0-9] ) o="${c}" ;;
          * )               printf -v o '%%%02x' "'$c"
       esac
       encoded+="${o}"
    done
    echo -n "${encoded}"
    echo -n %0A
  done
}

JS_Token=$Fastly_Token
SEQ="$1 $2"

#creating and naming a service
for i in `seq $SEQ`; do curl -H "Fastly-Key: $JS_Token" https://api.fastly.com/service -X POST --data "name=juice-Shop-${i}"; done

#setting the backend address
for i in `seq $SEQ`; do
  sid=`cat easy$i | jq --raw-output ".id"`
  curl -H "Fastly-Key: $JS_Token" https://api.fastly.com/service/${sid}/version/1/backend -X POST --data "address=juice-shop-fastly-${1}.herokuapp.com&name=juice-shop-fastly-${i} Origin"
done

#setting default_host
for i in `seq $SEQ`; do
  sid=`cat easy$i | jq --raw-output ".id"`
  curl -H "Fastly-Key: $JS_Token" https://api.fastly.com/service/${sid}/version/1/settings -X PUT --data "general.default_host=juice-shop-fastly-${i}.herokuapp.com"
done


for i in `seq $SEQ`; do
  sid=`cat easy$i | jq --raw-output ".id"`
  curl -H "Fastly-Key: $JS_Token" https://api.fastly.com/service/${sid}/version/1/domain -X POST --data "name=juice-shop-fastly-${i}.herokuapp.com"
done

for i in `seq $SEQ`; do
  sid=`cat easy$i | jq --raw-output ".id"`
  curl -H "Fastly-Key: $JS_Token" https://api.fastly.com/service/${sid}/version/1/activate -X PUT
done
########################################New Service
