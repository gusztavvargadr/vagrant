tentacle = node['gusztavvargadr_vagrant_octopus']['tentacle']

gusztavvargadr_vagrant_octopus_tentacle tentacle['instance_name'] do
  version tentacle['version']
  home_directory_path tentacle['home_directory_path']
  communication_port tentacle['communication_port']
  server_web_address tentacle['server_web_address']
  server_web_username tentacle['server_web_username']
  server_web_password tentacle['server_web_password']
  server_communication_port tentacle['server_communication_port']
  node_name tentacle['node_name']
  environment_name tentacle['environment_name']
  role_names tentacle['role_names']
  action [:install, :configure]
end
