#!/usr/bin/env bash

set -eo pipefail

mongod --dbpath=${MONGO_DBPATH} &

# try to import the first collection
# import sales
counter=10
while ! mongoimport /sales.json --db=test --collection=sales; do   
    ((counter--))
    if [[ $counter = 0 ]];then
        break
    fi
    sleep 5
done

# import restaurants
# now that we know db is up we can import the rest
mongoimport /restaurants.json --db=test --collection=restaurants;
# create 2dsphere index for geoNear command
mongo test --eval "db.restaurants.createIndex({ location: '2dsphere' })"
# create geoHaystack index for geoSearch command
mongo test --eval "db.restaurants.createIndex({ 'location.coordinates': 'geoHaystack', name: 1}, {bucketSize: 1})"

# import neighborhoods
mongoimport /neighborhoods.json --db=test --collection=neighborhoods;
# create 2dsphere index for geoNear command
mongo test --eval "db.neighborhoods.createIndex({ geometry: '2dsphere' })"

# shut down mongod
mongo admin --eval "db.shutdownServer({timeoutSecs: 3});"
sleep 3

chown -R mongodb:mongodb ${MONGO_DBPATH}
