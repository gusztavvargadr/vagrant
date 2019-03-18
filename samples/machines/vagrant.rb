directory = File.dirname(__FILE__)

require "#{directory}/../vagrant"

VagrantDeployment.defaults_include(
  'service' => 'machines'
)
