#! /bin/bash

set -e

DOCKER_BRIDGE_INTERFACE=`ifconfig docker0 | grep -w "inet" | awk '{print $2}'`

mkdir -p etc/catalog

cat > ./etc/catalog/example_cat.properties << EOF
# metastore
# https://trino.io/docs/current/connector/iceberg.html
connector.name=iceberg
iceberg.catalog.type=jdbc
iceberg.jdbc-catalog.default-warehouse-dir=s3://warehouse
iceberg.jdbc-catalog.catalog-name=example_cat
iceberg.jdbc-catalog.driver-class=org.postgresql.Driver
iceberg.jdbc-catalog.connection-url=jdbc:postgresql://${DOCKER_BRIDGE_INTERFACE}:5432/iceberg
iceberg.jdbc-catalog.connection-user=repl_user
iceberg.jdbc-catalog.connection-password=pass1234

# object store
# https://trino.io/docs/current/object-storage.html
fs.hadoop.enabled=false
fs.native-s3.enabled=true
s3.endpoint=http://${DOCKER_BRIDGE_INTERFACE}:9000
s3.region=us-east-1
s3.aws-access-key=minio_user
s3.aws-secret-key=pass1234
s3.path-style-access=true
EOF

docker compose up -d