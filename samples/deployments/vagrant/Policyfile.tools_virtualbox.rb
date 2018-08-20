name 'tools_virtualbox'

default_source :supermarket
default_source :chef_repo, 'cookbooks'

cookbook 'gusztavvargadr_vagrant'

run_list 'recipe[gusztavvargadr_vagrant::virtualbox]', 'recipe[gusztavvargadr_vagrant::tools]'
