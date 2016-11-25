git_profiles = node['gusztavvargadr_vagrant'].nil? ? nil : node['gusztavvargadr_vagrant']['git_profiles']
unless git_profiles.nil?
  git_profiles.each do |git_profile_address, git_profile_settings|
    git_profile_username = git_profile_settings['username']
    git_profile_password = git_profile_settings['password']

    unless git_profile_username.nil? || git_profile_password.nil?
      git_profile_uri = URI.parse(git_profile_address)
      git_profile_uri.userinfo = "#{git_profile_username}:#{git_profile_password}"
      git_profile_address = git_profile_uri.to_s
    end

    git_profile_checkout_directory_path = git_profile_settings['checkout_directory_path']
    git_profile_repositories = git_profile_settings['repositories']

    git_profile_repositories.each do |git_profile_repository_address, git_profile_repository_settings|
      git_repository_address = "#{git_profile_address}/#{git_profile_repository_address}"
      git_repository_checkout_directory_path = git_profile_checkout_directory_path
      if git_profile_repository_settings.nil? || git_profile_repository_settings['checkout_directory_path'].nil?
        git_repository_checkout_directory_path = "#{git_repository_checkout_directory_path}/#{git_profile_repository_address}"
      else
        git_repository_checkout_directory_path = "#{git_repository_checkout_directory_path}/#{git_profile_repository_settings['checkout_directory_path']}"
      end

      directory git_repository_checkout_directory_path do
        recursive true
        action :create
      end

      git git_repository_checkout_directory_path do
        repository git_repository_address
        checkout_branch 'master'
        enable_checkout false
        action :checkout
      end
    end
  end
end
