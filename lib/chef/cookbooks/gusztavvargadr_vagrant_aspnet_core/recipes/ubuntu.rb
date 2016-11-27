apt_repository 'dotnetdev' do
  uri 'https://apt-mo.trafficmanager.net/repos/dotnet-release/'
  distribution 'trusty'
  components ['main']
  arch 'amd64'
  keyserver 'keyserver.ubuntu.com'
  key '417A0893'
  action :add
end

apt_package 'dotnet-dev-1.0.0-preview2.1-003177' do
  action :install
end

include_recipe 'nodejs::nodejs_from_binary'

['yo', 'bower', 'generator-aspnet'].each do |npm_package|
  nodejs_npm npm_package do
    options ['-g']
    action :install
  end
end

link '/usr/local/bin/yo' do
  to '/usr/local/nodejs-binary/bin/yo'
  action :create
end
