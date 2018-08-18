name 'tools_virtualbox'

run_list 'recipe[gusztavvargadr_vagrant::virtualbox]', 'recipe[gusztavvargadr_vagrant::tools]'

default_source :supermarket
default_source :chef_repo, 'cookbooks'

cookbook 'gusztavvargadr_vagrant'
