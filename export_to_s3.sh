#!/bin/bash


# Constants
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
AWS_S3_BUCKET=$AWS_S3_BUCKET

# Install AWS CLI if it's not installed: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html for other installation method

# Upload to S3
echo "Uploading CSV files to S3..."
aws s3 cp path/to/file.csv s3://$AWS_S3_BUCKET
# Upload a directory
# aws s3 cp path/to/folder s3://$AWS_S3_BUCKET --recursive

echo "Done. 🍻"
