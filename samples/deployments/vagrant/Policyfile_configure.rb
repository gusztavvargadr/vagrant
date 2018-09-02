name 'configure'

default_source :supermarket
default_source :chef_repo, 'cookbooks'

cookbook 'gusztavvargadr_vagrant'

run_list 'recipe[gusztavvargadr_vagrant::plugins]'
