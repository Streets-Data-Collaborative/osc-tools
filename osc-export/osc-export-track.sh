#!/bin/bash
url="https://openstreetcam.org/details"
# need to log in to account to get the access token and view "unproccessed" OSC tracks.
# find the access token (in params tab of network in firefox) for api.openstreetcam.org (looking for api.openstreetcam.org is OK because the request is just getting the list of images from openstreetcam.org, and all it needs is some API key in the header). Replace ACCESS_TOKEN_HERE with the hex string that you found.
header="access_token=ACCESS_TOKEN_HERE&id=$1"
# also gets the JSON data of more data (such as elevation etc) collected in the images in case you want to view it (interesting)
curl $url --data $header -o osc_$1.json
# download full quality images on the server (not blurry thumbnails) with 100 threads for fast processing
cat osc_$1.json | jq ".osv.photos[].name" | xargs -I{} echo "www.openstreetcam.org/"{} >>urls_$1.txt 
cat urls_$1.txt | xargs -n 1 -P 100 wget
# to avoid redownloading the same image URLs if we re-run this script with the same track ID.
mv urls_$1.txt urls_$1_.txt
