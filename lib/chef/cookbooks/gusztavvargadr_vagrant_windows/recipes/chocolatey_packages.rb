chocolatey_packages = node['gusztavvargadr_vagrant_windows'].nil? ? nil : node['gusztavvargadr_vagrant_windows']['chocolatey_packages']
unless chocolatey_packages.nil?
  chocolatey_packages.each do |chocolatey_package_name, chocolatey_package_settings|
    chocolatey_package_version = chocolatey_package_settings.nil? ? nil : chocolatey_package_settings['version']
    chocolatey_package_options = chocolatey_package_settings.nil? ? nil : chocolatey_package_settings['options']

    if chocolatey_package_version.nil?
      chocolatey_package chocolatey_package_name do
        options "--ignorechecksums #{chocolatey_package_options}"
        action :upgrade
      end
    else
      chocolatey_package chocolatey_package_name do
        version chocolatey_package_version
        options "--ignorechecksums #{chocolatey_package_options}"
        action :upgrade
      end
    end
  end
end
