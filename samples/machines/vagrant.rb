directory = File.dirname(__FILE__)

require "#{directory}/../vagrant"

VagrantProvider.defaults_include(
  'memory' => 2048,
  'cpus' => 2
)
