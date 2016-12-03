property :project_file_path, String, name_property: true
property :server_web_address, String, required: true
property :api_key, String, required: true

action :import do
  powershell_script "Import project from #{project_file_path}" do
    code <<-EOH
      octo import --type=project --filePath=#{project_file_path} --server=#{server_web_address} --apiKey=#{api_key}
    EOH
    action :run
  end
end
