#!/bin/bash
./osc-get-raw-images.sh $1
mkdir $1/
mv *.jpg $1/
# the collected JSON files containing the image data can also go inside the track folder
mv osc_$1.json $1/
