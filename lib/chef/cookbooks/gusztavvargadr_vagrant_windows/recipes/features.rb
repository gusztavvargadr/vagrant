features = node['gusztavvargadr_vagrant_windows'].nil? ? nil : node['gusztavvargadr_vagrant_windows']['features']
unless features.nil?
  features.each do |feature_name|
    powershell_script "Enable Feature #{feature_name}" do
      code <<-EOH
        dism /online /enable-feature /featurename:#{feature_name} /all
      EOH
      action :run
    end
  end
end
