#!/bin/bash
url="http://openstreetcam.org/details"
header="access_token=0b6cf293c5f031815293f3fa19ebe75834c4f4b719b57975caed05d4297b876c&id=$1"
curl $url --data $header -o osc_$1.json
cat osc_$1.json | jq ".osv.photos[].th_name" | xargs -I{} echo "www.openstreetcam.org/"{} >>urls_$1.txt 
cat urls_$1.txt | xargs -n 1 -P 100 wget
convert -delay 20 -loop 0 *.jpg osc_$1.gif
rm *$1*.jpg
rm *$1*.txt
rm *$1*.json
