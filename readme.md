# Trino with Iceberg, Postgres, and MinIO

This is an example using Trino with an Iceberg connector, a Postgres metastore, and MinIO for object storage.

Start everything up:
```shell
docker compose up
```

Connect to the Trino controller to execute some SQL:
```shell
docker exec -it example-controller trino
```
