#!/bin/bash

# Constants
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
AWS_S3_BUCKET=$AWS_S3_BUCKET
AWS_CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
EXPORT_DIR="/app/.exports"
TMP_DOWNLOAD_DIR="/tmp"
AWS_INSTALL_DIR="/app/.awscli"
PG_HOST=$PG_HOST
PG_PORT=$PG_PORT
PG_DB=$PG_DB
PG_USER=$PG_USER
PG_PASSWORD=$PG_PASSWORD

# Ensure Exports directory exists
mkdir -p $EXPORT_DIR

# Function to check if a command exists
command_exists () {
  type "$1" &> /dev/null ;
}

# Install psql if it's not installed
if ! command_exists psql ; then
  echo "psql not found, installing..."
  sudo apt-get update
  sudo apt-get install postgresql-client -y
fi

# Install AWS CLI if it's not installed
if ! command_exists aws ; then
  echo "AWS CLI not found, installing..."
  mkdir -p "$TMP_DOWNLOAD_DIR"

  curl --silent --show-error -o "$TMP_DOWNLOAD_DIR/awscliv2.zip" "$AWS_CLI_URL"
  unzip -qq -d "$AWS_INSTALL_DIR" "$TMP_DOWNLOAD_DIR/awscliv2.zip"
  rm "$TMP_DOWNLOAD_DIR/awscliv2.zip"

  "$AWS_INSTALL_DIR/aws/install" -i "$AWS_INSTALL_DIR" -b "$AWS_INSTALL_DIR"/bin --update
  export PATH="$AWS_INSTALL_DIR/bin:$PATH"

  aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
  aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
  aws configure set default.region $AWS_DEFAULT_REGION
  aws --version
fi

if ! command_exists ./clickhouse ; then
  echo "ClickHouse not found, installing..."
  curl https://clickhouse.com/ | sh
fi
# Variant to export everything except somes tables
echo "Exporting and compressing tables to CSV..."
declare -a exclude_tables=("ar_metdata")
tables=$(./clickhouse local --query "SELECT tablename FROM postgresql('${PG_HOST}:${PG_PORT}', '${PG_DB}', 'pg_tables', '${PG_USER}', '${PG_PASSWORD}', 'pg_catalog') WHERE schemaname = 'public'" | grep -vFf <(printf "%s\n" "${exclude_tables[@]}"))
for TABLE_NAME in $tables; do
  ./clickhouse local --query "SELECT * FROM postgresql('${PG_HOST}:${PG_PORT}', '${PG_DB}', '${TABLE_NAME}', '${PG_USER}', '${PG_PASSWORD}') INTO OUTFILE '${EXPORT_DIR}/${TABLE_NAME}.parquet'"
done

# Upload to S3
echo "Uploading CSV files to S3..."
aws s3 cp $EXPORT_DIR s3://$AWS_S3_BUCKET --recursive

# Cleanup local files if you don't need to keep them
echo "Cleaning up local files..."
rm -rf $EXPORT_DIR

echo "Done. 🍻"
