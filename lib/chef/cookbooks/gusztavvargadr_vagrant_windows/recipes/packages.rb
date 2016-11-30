packages = node['gusztavvargadr_vagrant_windows'].nil? ? nil : node['gusztavvargadr_vagrant_windows']['packages']
unless packages.nil?
  packages.each do |package_name, package_settings|
    package_source = package_settings.nil? ? nil : package_settings['source']
    package_options = package_settings.nil? ? nil : package_settings['options']

    windows_package package_name do
      source package_source
      installer_type :custom
      options package_options
      action :install
    end
  end
end
