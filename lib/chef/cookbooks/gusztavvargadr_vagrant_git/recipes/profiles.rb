profiles = node['gusztavvargadr_vagrant_git'].nil? ? nil : node['gusztavvargadr_vagrant_git']['profiles']
unless profiles.nil?
  profiles.each do |profile_address, profile_settings|
    profile_username = profile_settings['username']
    profile_password = profile_settings['password']

    unless profile_username.nil? || profile_password.nil?
      profile_uri = URI.parse(profile_address)
      profile_uri.userinfo = "#{profile_username}:#{profile_password}"
      profile_address = profile_uri.to_s
    end

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

      git repository_checkout_directory_path do
        repository repository_address
        checkout_branch 'master'
        enable_checkout false
        action :checkout
      end
    end
  end
end
