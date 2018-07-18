#!/bin/bash
>osc_$1.csv
url="http://openstreetcam.org/details"
header="access_token=0b6cf293c5f031815293f3fa19ebe75834c4f4b719b57975caed05d4297b876c&id=$1"
curl -s $url --data $header -o osc_$1.json
num=`cat osc_$1.json | jq '.osv.count_active_photos' | tr -d \"`
meta_1=`cat osc_$1.json | jq '.osv.meta_data_filename' | tr -d \"`
metadata_url="http://openstreetcam.org/$meta_1"
metadata_url2=`curl -s $metadata_url | grep href | awk -F\" '{print $2}'`
echo $metadata_url2
curl -s $metadata_url2 -o osc_$1_sensorData.csv
count=0
accel_X_tot=0
accel_Y_tot=0
accel_Z_tot=0
accel_X_avg=0
accel_Y_avg=0
accel_Z_avg=0
lat_tot=0
lng_tot=0
centroid_lat=0
centroid_lng=0
echo "SQUID-URL,StreetID,Centroid_Latitude,Centroid_Longitude,SQUID_Score" >>osc_$1.csv
for i in $(tail -n +2 osc_$1_sensorData.csv)
do
 meta_lng=`echo $i | awk -F";" '{print $2}'`
 meta_lat=`echo $i | awk -F";" '{print $3}'`
 accel_X=`echo $i | awk -F";" '{print $10}'`
 accel_Y=`echo $i | awk -F";" '{print $11}'`
 accel_Z=`echo $i | awk -F";" '{print $12}'`
 #echo "$meta_lng,$meta_lat,$accel_X,$accel_Y,$accel_Z"
 if [[  -z  $meta_lat && ! -z $accel_X ]]
 then
  #echo "No location:$accel_X,$accel_Y,$accel_Z"
  count=`expr $count + 1`
  accel_X_tot=`echo "$accel_X_tot + $accel_X" | bc -l`
  accel_Y_tot=`echo "$accel_Y_tot + $accel_Y" | bc -l`
  accel_Z_tot=`echo "$accel_Z_tot + $accel_Z" | bc -l`
 fi
 if [[ !  -z  $meta_lat  ]]
 then
  accel_X_avg=`echo "$accel_X_tot / $count" | bc -l`
  accel_Y_avg=`echo "$accel_Y_tot / $count" | bc -l`
  accel_Z_avg=`echo "$accel_Z_tot / $count" | bc -l`
  score=`echo "sqrt(($accel_X_avg * $accel_X_avg) + ($accel_Y_avg * $accel_Y_avg) + ($accel_Z_avg * $accel_Z_avg))" | bc`
  lat_tot=`echo "$lat_tot + $meta_lat" | bc -l`
  lng_tot=`echo "$lng_tot + $meta_lng" | bc -l`
  count2=`expr $count2 + 1`
  squid_url="http://openstreetcam.org/details/${1}/0"
  count=0
  count2=1
  #echo "YES LOCATION: $meta_lat,$meta_lng,$accel_X_avg,$accel_Y_avg,$accel_Z_avg"
  geonames_url="http://api.geonames.org/findNearbyStreets?lat=$meta_lat&lng=$meta_lng&username=stwf"
  #echo $geonames_url
  from_before=$from
  #curl -s $geonames_url | /home/ubuntu/node_modules/xml2json/bin/xml2json | jq '.geonames.streetSegment[2]'
  #geoname_txt=`curl -s $geonames_url | /home/ubuntu/node_modules/xml2json/bin/xml2json | jq '.geonames.streetSegment[2]'`
  geoname_txt=`curl -s $geonames_url | xml2json | jq '.geonames.streetSegment[2]'`
  #echo $geoname_txt
  from=`echo $geoname_txt | jq '.fraddr' | tr -d \"`

  if [[ -z $from ]]
  then
   from=`echo $geoname_txt | jq '.fraddl' | tr -d \"`
  fi
  
  to=`echo $geoname_txt | jq '.toaddr' | tr -d \"`
  if [[ -z $to ]]
  then
   to=`echo $geoname_txt | jq '.toaddl' | tr -d \"`
  fi
  
  name=`echo $geoname_txt | jq '.name' | tr -d \"`
  
  if [[ $from == $from_before ]]
  then
    echo "do nothing" >>/dev/null
    #echo "Froms equal",$centroid_lat,$centroid_lng
  elif [[ ( $from -ne $from_before ) ]]
  then
     #echo "$from,$to,$name,$from_before,$count2"
     echo "nithing" >>/dev/null
     if [[ $count2 -eq 1 ]]
     then
       centroid_lat=`echo "$lat_tot / $count2" | bc -l`
       centroid_lng=`echo "$lng_tot / $count2" | bc -l`
       echo "$squid_url,$from-$to $name,$centroid_lat,$centroid_lng,$score" >>osc_$1.csv
     fi
  fi
  count2=1
  centroid_lat=0
  centroid_lng=0
  lat_tot=0
  lng_tot=0
  score=0
  accel_X_avg=0
  accel_Y_avg=0
  accel_Z_avg=0
 fi
done

csv2json osc_$1.csv ./osc_jsons/osc_$1.json
cat ./osc_jsons/osc_$1.json
