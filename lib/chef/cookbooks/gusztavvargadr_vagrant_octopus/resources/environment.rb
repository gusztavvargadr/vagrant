property :environment_name, String, name_property: true
property :server_web_address, String, required: true
property :api_key, String, required: true

action :create do
  powershell_script "Create environment #{environment_name}" do
    code <<-EOH
      octo create-environment --name=#{environment_name} --ignoreIfExists --server=#{server_web_address} --apiKey=#{api_key}
    EOH
    action :run
  end
end
