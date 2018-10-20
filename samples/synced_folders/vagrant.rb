directory = File.dirname(__FILE__)

require "#{directory}/../vagrant"

VagrantMachine.defaults_include(
  'synced_folders' => {
    '/vagrant' => {
      'disabled' => true,
    },
  }
)
