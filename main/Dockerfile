# image with test data
FROM mongo:3.2.4

COPY sales.json /
COPY restaurants.json /
COPY neighborhoods.json /

# designate a new data directory (the original one is volumized, no data is persisted)
ENV MONGO_DBPATH /data/test-db
RUN mkdir -p ${MONGO_DBPATH} && chown -R mongodb:mongodb ${MONGO_DBPATH}

COPY import-test-data.sh /
RUN /import-test-data.sh

CMD ["mongod", "--dbpath=/data/test-db"];
