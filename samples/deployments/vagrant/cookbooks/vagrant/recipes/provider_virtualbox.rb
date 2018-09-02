chocolatey_package 'virtualbox' do
  version '5.2.16'
  action :install
end

windows_env 'VAGRANT_PREFERRED_PROVIDERS' do
  value 'virtualbox'
  action :create
end
