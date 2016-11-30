profiles = node['gusztavvargadr_vagrant_nuget'].nil? ? nil : node['gusztavvargadr_vagrant_nuget']['profiles']
unless profiles.nil?
  profiles.each do |profile_address, profile_settings|
    profile_name = profile_settings['name'].nil? ? profile_address : profile_settings['name']

    powershell_script_code = "NuGet sources Add -Name #{profile_name} -Source #{profile_address}"

    profile_username = profile_settings['username']
    profile_password = profile_settings['password']

    unless profile_username.nil? || profile_password.nil?
      powershell_script_code = "#{powershell_script_code} -UserName #{profile_username} -Password #{profile_password} -StorePasswordInClearText"
    end

    powershell_script "Add NuGet source #{profile_name}" do
      code powershell_script_code
      action :run
    end    
  end
end
