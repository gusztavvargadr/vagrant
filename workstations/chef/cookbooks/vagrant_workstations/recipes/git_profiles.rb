git_profiles = node['vagrant_workstations'].nil? ? nil : node['vagrant_workstations']['git_profiles']
unless git_profiles.nil?
  git_profiles.each do |git_profile_url, git_profile_settings|
    git_profile_checkout_directory_path = git_profile_settings['checkout_directory_path']
    git_profile_repositories = git_profile_settings['repositories']

    git_profile_repositories.each do |git_profile_repository_url, git_profile_repository_settings|
      git_repository_url = "#{git_profile_url}/#{git_profile_repository_url}"
      git_repository_checkout_directory_path = git_profile_checkout_directory_path
      if git_profile_repository_settings.nil? || git_profile_repository_settings['checkout_directory_path'].nil?
        git_repository_checkout_directory_path = "#{git_repository_checkout_directory_path}/#{git_profile_repository_url}"
      else
        git_repository_checkout_directory_path = "#{git_repository_checkout_directory_path}/#{git_profile_repository_settings['checkout_directory_path']}"
      end

      directory git_repository_checkout_directory_path do
        recursive true
        action :create
      end

      git git_repository_checkout_directory_path do
        repository git_repository_url
        checkout_branch 'master'
        enable_checkout false
        action :checkout
      end
    end
  end
end
