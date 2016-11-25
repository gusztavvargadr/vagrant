property :feature_name, String, name_property: true

action :enable do
  powershell_script "Enable Windows Feature #{feature_name}" do
    code <<-EOH
      dism /online /enable-feature /featurename:#{feature_name} /all
    EOH
    action :run
  end
end
