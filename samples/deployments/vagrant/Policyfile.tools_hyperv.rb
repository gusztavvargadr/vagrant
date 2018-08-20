name 'tools_hyperv'

default_source :supermarket
default_source :chef_repo, 'cookbooks'

cookbook 'gusztavvargadr_vagrant'

run_list 'recipe[gusztavvargadr_vagrant::hyperv]', 'recipe[gusztavvargadr_vagrant::tools]'
