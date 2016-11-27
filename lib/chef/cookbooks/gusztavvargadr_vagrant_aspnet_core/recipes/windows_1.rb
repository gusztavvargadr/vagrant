windows_package '.NET Core SDK' do
  source 'https://download.microsoft.com/download/1/4/1/141760B3-805B-4583-B17C-8C5BC5A876AB/Installers/dotnet-dev-win-x64.1.0.0-preview2-1-003177.exe'
  installer_type :custom
  options '/install /quiet /norestart'
  action :install
end

chocolatey_package 'nodejs' do
  action :install
end
