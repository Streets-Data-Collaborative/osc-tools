#!/bin/bash

 # When logged into OSC account, in a JavaScript console, run:
 # [...document.links].map(l => l.href).filter((a_url) => a_url.startsWith("https://openstreetcam.org/details")).toString()
 # (used startsWith to remove instances of javascript:void(0)) to get this:

 # (this can be automated by doing cURL and extracting the browser cookie or API access token in the header to get both processed and unprocessed tracks for the logged in  account)
 
 # Result (output):
 # "https://openstreetcam.org/details/2084134,https://openstreetcam.org/details/2084130,[...]"
 # Paste the URLs you get, with the quotes at the beginning and end, in this variable (an example is shown below):
 
 #URLs="https://openstreetcam.org/details/2084134,https://openstreetcam.org/details/2084130,https://openstreetcam.org/details/123456"
 
 URLs=""
 
 # What the rest of this script does:
 # find and replace https://openstreetcam.org/details/ to nothing once to get track IDs:
 # 2084134,2084130,[...]
 
 # find and replace again to get spaces instead of commas:
 # 2084134 2084130 [...]
 
 TracksSpaceSepd="${URLs//https:\/\/openstreetcam.org\/details\//}"
 TracksSpaceSepd="${TracksSpaceSepd//,/ }"
 
 for track in $TracksSpaceSepd; do
    ./osc-export-track-into-folder.sh $track;
 done
