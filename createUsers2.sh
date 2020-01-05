#!/bin/bash

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


#Fastly_Token=""
SEQ="$1 $2"

#creating and naming a service
for i in `seq $SEQ`; do curl -H "Fastly-Key: $Fastly_Token" https://api.fastly.com/user -X POST --data "name=DeniseTest${i}&login=dmccoy+test${1}.fastly.com"; done
