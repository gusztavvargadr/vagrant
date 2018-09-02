windows_feature 'Microsoft-Hyper-V-All' do
  action :install
end

windows_env 'VAGRANT_PREFERRED_PROVIDERS' do
  value 'hyperv'
  action :create
end

windows_env 'VAGRANT_PROVIDER_HYPERV_SMB_USERNAME' do
  value 'vagrant'
  action :create
end

windows_env 'VAGRANT_PROVIDER_HYPERV_SMB_PASSWORD' do
  value 'vagrant'
  action :create
end
