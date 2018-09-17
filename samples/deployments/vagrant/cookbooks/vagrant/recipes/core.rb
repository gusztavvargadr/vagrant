chocolatey_package 'vagrant' do
  version '2.1.5'
  returns [0, 3010]
  action :install
end

windows_env 'VAGRANT_PROVIDER_LINKED_CLONE' do
  value 'true'
  action :create
end
