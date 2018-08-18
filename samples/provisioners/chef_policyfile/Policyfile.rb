name 'hello_world'

run_list 'recipe[hello_world::default]'

default_source :supermarket

cookbook 'hello_world'
