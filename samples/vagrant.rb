directory = File.dirname(__FILE__)

require "#{directory}/../src/vagrant"

class VagrantWindowsDesktopMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_WINDOWS_DESKTOP'] || 'gusztavvargadr/windows-10',
  }
end

class VagrantWindowsServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_WINDOWS_SERVER'] || 'gusztavvargadr/windows-server',
  }
end

class VagrantLinuxDesktopMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_LINUX_DESKTOP'] || 'gusztavvargadr/ubuntu-desktop',
  }
end

class VagrantLinuxServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_LINUX_SERVER'] || 'gusztavvargadr/ubuntu-server',
  }
end

class VagrantDockerWindowsMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_DOCKER_WINDOWS'] || 'gusztavvargadr/docker-windows',
  }
end

class VagrantDockerLinuxMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_DOCKER_LINUX'] || 'gusztavvargadr/docker-linux',
  }
end

VagrantDeployment.defaults_include(
  'stack' => 'vagrant',

  'machines' => {
    'windows' => {
      'box' => VagrantWindowsServerMachine.defaults['box'],
    },
    'linux' => {
      'box' => VagrantLinuxServerMachine.defaults['box'],
      'azure_image_urn' => 'Canonical:UbuntuServer:16.04-LTS:latest',
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
