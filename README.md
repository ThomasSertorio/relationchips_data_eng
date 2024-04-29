# Relationchips Data Engineering Snippets

This repo gathers some snippets to move data around. In details:

- A [bash script](pgsql_csv_export_to_s3.sh) to extract tables out of a PostgreSQL Database and export them as CSV on an AWS S3 Bucket. This script can be run in a CRON job.
- A [Google Cloud Function](gcs_to_aws_s3/README.md) to react on new file in GCS and export them to an AWS S3 Bucket.
- A [Google Cloud Function](gcsql_to_csv/README.md) to extract tables out of a Google Cloud SQL Instance and export them on a GCS Bucket.
