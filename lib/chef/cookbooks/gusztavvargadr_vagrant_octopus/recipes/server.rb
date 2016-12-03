server = node['gusztavvargadr_vagrant_octopus']['server']

gusztavvargadr_vagrant_octopus_server server['instance_name'] do
  version server['version']
  home_directory_path server['home_directory_path']
  service_username server['service_username']
  storage_server_name server['storage_server_name']
  storage_database_name server['storage_database_name']
  web_address server['web_address']
  web_username server['web_username']
  web_password server['web_password']
  communication_port server['communication_port']
  node_name server['node_name']
  action [:install, :configure]
end

api_key = server['api_key']
unless api_key.to_s == ''
  chocolatey_package 'octopustools' do
    action :upgrade
  end

  environment_names = server['environment_names']
  environment_names.each do |environment_name|
    gusztavvargadr_vagrant_octopus_environment environment_name do
      server_web_address server['web_address']
      api_key api_key
      action :create
    end
  end

  project_file_paths = server['project_file_paths']
  project_file_paths.each do |project_file_path|
    gusztavvargadr_vagrant_octopus_project project_file_path do
      server_web_address server['web_address']
      api_key api_key
      action :import
    end
  end
end
