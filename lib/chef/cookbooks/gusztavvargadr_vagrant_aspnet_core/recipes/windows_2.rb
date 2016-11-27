['yo', 'bower', 'generator-aspnet'].each do |npm_package|
  powershell_script "Install NPM package #{npm_package}" do
    code <<-EOH
      npm install -g #{npm_package}
    EOH
    returns [0, 1]
    action :run
  end
end
