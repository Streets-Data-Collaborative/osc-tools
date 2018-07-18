# osc-tools

[**osc-parse.sh**](https://github.com/Streets-Data-Collaborative/osc-tools/blob/master/osc-parse.sh "osc-parse.sh") download's all the files for a specific OSC track_id.

Requirements: 
- [jq](https://stedolan.github.io/jq/)

Usage: 
```
./osc-parse.sh 123456
```
Platform specific instructions: 
``` 
This code works on OSX and uses ghead. To run on Linux platforms, simply change ghead to head.
```
Outputs: 
**123456.csv: Contains all the point data for that track**

 - id 
 - sequence_id 
 - sequence_index 
 - lat 
 - lng 
 - fileName 
 - name 
 - lth_name 
 - th_name
 - path 
 - date_added 
 - timestamp 
 - way_id 
 - match_lat 
 - match_lng 
 - heading
 - gps_accuracy 
 - storage 
 - shot_date 
 - projection

**123456-m.csv: Contains the metadata for that track** (Single row for each track
- date_added
- platform
- user
- user_id
- meta_data_filename
- address
- reviewed
- distance
- changed
- obd_info
- count_active_photos
- recognitions
- client_total
- is_rotating
- owner
- upload_history.id
- upload_history.sequence_id
- upload_history.user_id
- upload_history.user_category
- upload_history.distance
- upload_history.has_obd

---

[**squid-souq.sh**](https://github.com/Streets-Data-Collaborative/osc-tools/blob/master/squid-souq.sh "squid-souq.sh") accepts a track-id and integrates the point  & sensor data for a single track id to output a simple csv file:
 - The URL of the OSC track
 - GeoStreetTalk'd line segment using the [geonames service](http://api.geonames.org/findNearbyStreets?lat=37.451&lng=-122.18&username=demo)
 - Centroid of the line segment.
 - SQUID score that represents the underlying accelerometer data.

This script uses the geonames service to calculate Street Segment IDs

Requirements:
- [jq](https://stedolan.github.io/jq/)
- [xml2json](https://www.npmjs.com/package/xml2json)
- [csv2json](https://www.npmjs.com/package/csv2json)

Usage: 
```
./squid-souq.sh 123456
```
Outputs:
osc_123456.csv - The parsed file
osc_123456.json - Raw Output
osc_123456_sensorData.csv - Raw Output

