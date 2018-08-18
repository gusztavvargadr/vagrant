name 'extensions'

run_list 'recipe[gusztavvargadr_vagrant::extensions]'

default_source :supermarket
default_source :chef_repo, 'cookbooks'

cookbook 'gusztavvargadr_vagrant'
