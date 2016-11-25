windows_packages = node['gusztavvargadr_vagrant'].nil? ? nil : node['gusztavvargadr_vagrant']['windows_packages']
unless windows_packages.nil?
  windows_packages.each do |windows_package_name, windows_package_settings|
    windows_package_source = windows_package_settings.nil? ? nil : windows_package_settings['source']
    windows_package_options = windows_package_settings.nil? ? nil : windows_package_settings['options']

    windows_package windows_package_name do
      source windows_package_source
      installer_type :custom
      options windows_package_options
      action :install
    end
  end
end
