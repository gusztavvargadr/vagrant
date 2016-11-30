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
  action [:install, :configure]
end
