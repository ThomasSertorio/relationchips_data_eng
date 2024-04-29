# Google Cloud SQL Instance To CSV in GCS Bucket

This Google Cloud function exports in CSV some tables out of a database and transfers them to a GCS Bucket. It is designed to be triggered on regular basis through a HTTP Trigger.

## Deployment

To deploy it:

```bash
cd gcsql_to_csv

gcloud functions deploy export_csv \
  --runtime ruby27 \
  --trigger-http --allow-unauthenticated \
  --set-env-vars PROJECT_ID=your_project_id,INSTANCE_ID=your_instance_id,BUCKET_NAME=your_bucket_name
```

⚠️ Make sure to replace your_project_id, your_instance_id, your_bucket_name by their real values.

To run it regularly:

```bash
gcloud scheduler jobs create http export-job --schedule "0 * * * *" --uri "FUNCTION_URL" --http-method GET
```

⚠️ Make sure to replace FUNCTION_URL by the id the deployed Google Cloud Function.
