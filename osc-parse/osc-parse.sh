#!/bin/bash
osc_id=$1
response=`curl -s "http://openstreetcam.org/details" --data "id=${osc_id}"`
tail_num=`echo $response | jq .[] | grep -nw photos | awk -F\: '{print $1}'`
echo $response | jq .[] | tail -n +$tail_num | sed 's/"photos"://g'  | ghead -n -1 | json2csv >$osc_id.csv
echo $response | jq .[] | tail -n +7 | head -23 | sed  '$ s/.$/}}/' | json2csv -F >$osc_id-m.csv
