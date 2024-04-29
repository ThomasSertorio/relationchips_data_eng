# GCS To AWS S3 Bucket

This Google Cloud function transfers a file from a GCS Bucket to an AWS S3 Bucket. It is designed to be triggered every time a file is uploaded on a GCS Bucket (`trigger-event: google.storage.object.finalize`).

## Deployment

To deploy it:

```bash
cd gcs_to_aws_s3

gcloud functions deploy transfer_file_to_s3 \
 --runtime ruby27 \
 --entry-point transfer_file_to_s3 \
 --trigger-resource your_gcs_bucket_name \
 --trigger-event google.storage.object.finalize \
 --set-env-vars AWS_ACCESS_KEY_ID='your_aws_access_key_id',AWS_SECRET_ACCESS_KEY='your_aws_secret_access_key',AWS_DEFAULT_REGION='your_aws_default_region',AWS_S3_BUCKET='your_aws_s3_bucket'
```

⚠️ Make sure to replace your_gcs_bucket_name, your_aws_access_key_id, your_aws_secret_access_key, your_aws_default_region, your_aws_s3_bucket by their real values.
