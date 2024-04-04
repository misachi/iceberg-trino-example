# Trino with Iceberg

This is an attempt to get Trino working with an Iceberg connection using Postgres for a metastore and MinIO for object storage.

Start everything up:
```shell
docker compose up
```

Connect to the Trino controller to execute some SQL:
```shell
docker exec -it example-controller trino
```

Try creating a new table:
```sql
trino> CREATE SCHEMA example.schema1;
trino> CREATE TABLE example.schema1.table1 (id bigint);
Query 20240404_181753_00006_5uvvn failed: Failed checking new table's location: s3://warehouse/schema1/table1-1fc845f899ca4391bfd3bec08c359dae
```

Table creation fails because the `s3://warehouse` location is not accessible.

In the logs from `docker compose up`, see the following `ICEBERG_FILESYSTEM_ERROR` (with no additional detail):
```
example-controller    | 2024-04-04T18:17:54.462Z	INFO	dispatcher-query-8	io.trino.event.QueryMonitor	TIMELINE: Query 20240404_181753_00006_5uvvn :: FAILED (ICEBERG_FILESYSTEM_ERROR) :: elapsed 768ms :: planning 768ms :: waiting 0ms :: scheduling 0ms :: running 0ms :: finishing 0ms :: begin 2024-04-04T18:17:53.676Z :: end 2024-04-04T18:17:54.444Z
```

Confirm that we can create a bucket manually with `mc`:
```shell
docker run -it --network=trino-example_default --entrypoint=/bin/sh minio/mc:RELEASE.2024-03-30T15-29-52Z
```

```shell
mc alias set minio http://object-store:9000 minio-user minio-password
mc mb minio/warehouse
mc anonymous set public minio/warehouse
```

Even after creating the publicly accessible `warehouse` bucket, the `CREATE TABLE` statement above fails with the same error.
