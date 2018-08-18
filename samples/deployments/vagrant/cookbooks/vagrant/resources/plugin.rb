property :name, String, name_property: true
property :version, String, required: true

default_action :install

action :install do
  powershell_script "Install plugin #{new_resource.name} version #{new_resource.version}" do
    code <<-EOH
      vagrant plugin install vagrant-#{new_resource.name} --plugin-version #{new_resource.version}
    EOH
    not_if "((vagrant plugin list) -match 'vagrant-#{new_resource.name}').Length -gt 0"
    action :run
  end
end
