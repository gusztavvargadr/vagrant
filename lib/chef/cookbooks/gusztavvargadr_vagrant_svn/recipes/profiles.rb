profiles = node['gusztavvargadr_vagrant_svn'].nil? ? nil : node['gusztavvargadr_vagrant_svn']['profiles']
unless profiles.nil?
  profiles.each do |profile_address, profile_settings|
    profile_username = profile_settings['username']
    profile_password = profile_settings['password']

    profile_checkout_directory_path = profile_settings['checkout_directory_path']
    profile_repositories = profile_settings['repositories']

    profile_repositories.each do |profile_repository_address, profile_repository_settings|
      repository_address = "#{profile_address}/#{profile_repository_address}"
      repository_checkout_directory_path = profile_checkout_directory_path
      if profile_repository_settings.nil? || profile_repository_settings['checkout_directory_path'].nil?
        repository_checkout_directory_path = "#{repository_checkout_directory_path}/#{profile_repository_address}"
      else
        repository_checkout_directory_path = "#{repository_checkout_directory_path}/#{profile_repository_settings['checkout_directory_path']}"
      end

      directory repository_checkout_directory_path do
        recursive true
        action :create
      end

      subversion repository_address do
        repository repository_address
        destination repository_checkout_directory_path
        svn_username profile_username
        svn_password profile_password
        action :checkout
      end
    end
  end
end
