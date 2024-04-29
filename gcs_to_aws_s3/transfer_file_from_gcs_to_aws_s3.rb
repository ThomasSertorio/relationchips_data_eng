require "google/cloud/storage"
require "aws-sdk-s3"

def transfer_file_to_s3(data, context)
  initialize_aws_s3
  gcs_filename = data["name"]
  bucket_name = data["bucket"]

  storage = Google::Cloud::Storage.new
  bucket = storage.bucket(bucket_name)
  file = bucket.file(gcs_filename)

  # Download the file temporarily
  temp_file = "/tmp/#{gcs_filename}"
  file.download temp_file

  # Upload to S3
  s3_upload(bucket_name, gcs_filename, temp_file)
end

def initialize_aws_s3
  Aws.config.update({
    region: ENV['AWS_DEFAULT_REGION'],
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
  })
end

def s3_upload(bucket_name, file_name, file_path)
  s3 = Aws::S3::Resource.new
  obj = s3.bucket(ENV['AWS_S3_BUCKET']).object(file_name)
  obj.upload_file(file_path)
end
