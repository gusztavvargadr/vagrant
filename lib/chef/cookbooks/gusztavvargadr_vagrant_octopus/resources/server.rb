property :instance_name, String, name_property: true
property :version, String, required: true
property :home_directory_path, String, required: true
property :service_username, String, required: true
property :storage_server_name, String, required: true
property :storage_database_name, String, required: true
property :web_address, String, required: true
property :web_username, String, required: true
property :web_password, String, required: true
property :communication_port, Integer, required: true
property :node_name, String, required: true

action :install do
  windows_package_name = instance_name
  windows_package_source = "https://download.octopusdeploy.com/octopus/Octopus.#{version}.msi"
  windows_package_options = '/quiet /norestart'

  windows_package windows_package_name do
    source windows_package_source
    installer_type :custom
    options windows_package_options
    action :install
    not_if { ::File.exist?('/Program Files/Octopus Deploy/Octopus/Octopus.Server.exe') }
  end
end

action :configure do
  script_directory_path = "#{Chef::Config[:file_cache_path]}/gusztavvargadr_vagrant_octopus/server"

  directory script_directory_path do
    recursive true
    action :create
  end

  script_file_name = "#{instance_name}_configure.bat"
  script_file_path = "#{script_directory_path}\\#{script_file_name}"
  executable_file_path = 'C:\\Program Files\\Octopus Deploy\\Octopus\\Octopus.Server.exe'

  file script_file_path do
    content <<-EOH
      "#{executable_file_path}" create-instance --instance "#{instance_name}" --config "#{home_directory_path}\\#{instance_name}.config" --console
      "#{executable_file_path}" configure --instance "#{instance_name}" --home "#{home_directory_path}" --storageConnectionString "Data Source=#{storage_server_name};Initial Catalog=#{storage_database_name};Integrated Security=True" --upgradeCheck "False" --upgradeCheckWithStatistics "False" --webAuthenticationMode "UsernamePassword" --webForceSSL "False" --webListenPrefixes "#{web_address}" --commsListenPort "#{communication_port}" --serverNodeName "#{node_name}" --console
      "#{executable_file_path}" database --instance "#{instance_name}" --create --grant "#{service_username}" --console
      "#{executable_file_path}" service --instance "#{instance_name}" --stop --console
      "#{executable_file_path}" admin --instance "#{instance_name}" --username "#{web_username}" --password "#{web_password}" --console
      "#{executable_file_path}" service --instance "#{instance_name}" --install --reconfigure --start --console
    EOH
    action :create
  end

  powershell_script "Create Octopus Server instance #{instance_name}" do
    cwd script_directory_path
    code <<-EOH
      .\\#{script_file_name} > #{script_file_name}.log
    EOH
    action :run
    not_if { ::File.exist?("#{home_directory_path}\\#{instance_name}.config") }
  end

  web_port = URI(web_address).port
  powershell_script "Enable Octopus Server instance #{instance_name} web port #{web_port}" do
    code <<-EOH
      netsh advfirewall firewall add rule "name=Octopus Server #{instance_name} Web #{web_port}" dir=in action=allow protocol=TCP localport=#{web_port}
    EOH
    action :run
  end

  powershell_script "Enable Octopus Server instance #{instance_name} communication port #{communication_port}" do
    code <<-EOH
      netsh advfirewall firewall add rule "name=Octopus Server #{instance_name} Communication #{communication_port}" dir=in action=allow protocol=TCP localport=#{communication_port}
    EOH
    action :run
  end
end
