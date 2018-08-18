directory = File.dirname(__FILE__)

require "#{directory}/../vagrant"

VagrantMachine.defaults_include(
  'box' => VagrantLinuxServerMachine.defaults['box']
)
