directory = File.dirname(__FILE__)

require "#{directory}/../vagrant"

VagrantDeployment.defaults_include(
  'machines' => {
    'linux' => {
      'box' => VagrantLinuxServerMachine.defaults['box'],
    },
    'windows' => {
      'box' => VagrantWindowsServerMachine.defaults['box'],
    },
  }
)

VagrantProvider.defaults_include(
  'memory' => 2048,
  'cpus' => 2
)
