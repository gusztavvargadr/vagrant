windows_features = node['gusztavvargadr_vagrant'].nil? ? nil : node['gusztavvargadr_vagrant']['windows_features']
unless windows_features.nil?
  windows_features.each do |windows_feature_name|
    powershell_script "Enable Windows Feature #{windows_feature_name}" do
      code <<-EOH
        dism /online /enable-feature /featurename:#{windows_feature_name} /all
      EOH
      action :run
    end
  end
end
