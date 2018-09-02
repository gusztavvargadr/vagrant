chocolatey_package 'chefdk' do
  version '3.1.0'
  action :install
end

chocolatey_package 'git' do
  version '2.18.0'
  options '--params "/GitAndUnixToolsOnPath /NoShellIntegration"'
  action :install
end
