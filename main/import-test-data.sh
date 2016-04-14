#!/usr/bin/env bash

set -eo pipefail

mongod --dbpath=${MONGO_DBPATH} &

# try to import the first collection
counter=10
while ! mongoimport /sales.json --db=test --collection=sales; do   
    ((counter--))
    if [[ $counter = 0 ]];then
        break
    fi
    sleep 5
done

# now that we know db is up we can import the rest
mongoimport /restaurants.json --db=test --collection=restaurants;
mongoimport /neighborhoods.json --db=test --collection=neighborhoods;

mongo admin --eval "db.shutdownServer({timeoutSecs: 3});"
sleep 3

chown -R mongodb:mongodb ${MONGO_DBPATH}
