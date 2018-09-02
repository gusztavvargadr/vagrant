name 'install_hyperv'

default_source :supermarket
default_source :chef_repo, 'cookbooks'

cookbook 'gusztavvargadr_vagrant'

run_list(
  'recipe[gusztavvargadr_vagrant::core]',
  'recipe[gusztavvargadr_vagrant::provider_hyperv]',
  'recipe[gusztavvargadr_vagrant::provisioner_chef]'
)
