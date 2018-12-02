directory = File.dirname(__FILE__)

require "#{directory}/../src/vagrant"

class VagrantLinuxServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_LINUX_SERVER'] || 'gusztavvargadr/u16s-dc',
  }
end

class VagrantLinuxDesktopMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_LINUX_DESKTOP'] || 'gusztavvargadr/u16d-dc',
  }
end

class VagrantWindowsServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_WINDOWS_SERVER'] || 'gusztavvargadr/w16sc-de',
  }
end

class VagrantWindowsDesktopMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_WINDOWS_DESKTOP'] || 'gusztavvargadr/w16s-dc',
  }
end

VagrantDeployment.defaults_include(
  'stack' => 'vagrant',

  'machines' => {
    'linux' => {
      'box' => VagrantLinuxServerMachine.defaults['box'],
      'azure_image_urn' => 'Canonical:UbuntuServer:16.04-LTS:latest',
    },
    'windows' => {
      'box' => VagrantWindowsServerMachine.defaults['box'],
    },
  }
)

VagrantMachine.defaults_include(
  'providers' => {
    'virtualbox' => {},
    'hyperv' => {},
    'azure' => {},
  }
)

VagrantProvider.defaults_include(
  'memory' => 2048,
  'cpus' => 2,
  'azure_size' => 'Standard_B2s'
)
