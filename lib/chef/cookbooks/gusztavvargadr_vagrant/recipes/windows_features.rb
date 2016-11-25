windows_features = node['gusztavvargadr_vagrant'].nil? ? nil : node['gusztavvargadr_vagrant']['windows_features']
unless windows_features.nil?
  windows_features.each do |windows_feature_name|
    gusztavvargadr_vagrant_windows_feature windows_feature_name do
      action :enable
    end
  end
end
