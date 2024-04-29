require "google/apis/sqladmin_v1beta4"
require "functions_framework"

include Google::Apis::SqladminV1beta4

FunctionsFramework.http "export_csv" do |request|
  project_id = ENV['PROJECT_ID']
  instance_id = ENV['INSTANCE_ID']
  bucket_name = ENV['BUCKET_NAME']

  sqladmin_service = SqladminService.new
  sqladmin_service.authorization = Google::Auth.get_application_default(["https://www.googleapis.com/auth/sqlservice.admin"])

  tables = {
    "table1" => "SELECT * FROM table1",
    "table2" => "SELECT * FROM table2",
    "table3" => "SELECT * FROM table3"
  }

  responses = []

  tables.each do |table_name, query|
    file_name = "#{Time.now.strftime('%Y%m%d%H%M')}_#{table_name}.csv"
    uri = "gs://#{bucket_name}/#{file_name}"

    export_request = ExportContext.new(
      kind: "sql#exportContext",
      file_type: "CSV",
      uri: uri,
      databases: ['your-database-name'],
      csv_export_options: CsvExportOptions.new(select_query: query)
    )

    begin
      response = sqladmin_service.export_instance(project_id, instance_id, InstancesExportRequest.new(export_context: export_request))
      responses << "Export for #{table_name} started successfully: #{response.name}"
    rescue => e
      responses << "Failed to start export for #{table_name}: #{e.message}"
    end
  end

  responses.join("\n")
end
