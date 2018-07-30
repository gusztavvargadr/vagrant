require "#{File.dirname(__FILE__)}/../src/vagrant"

VagrantProvider.defaults({
  'memory' => 2048,
  'cpus' => 2,
})
