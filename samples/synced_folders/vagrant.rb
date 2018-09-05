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

VagrantMachine.defaults_include(
  'synced_folders' => {
    '/vagrant' => {
      'disabled' => true,
    },
  }
)
