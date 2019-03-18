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
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_PROVIDERS_AZURE_IMAGE_URN_LINUX_SERVER'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
      },
    },
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
      'providers' => VagrantLinuxServerMachine.defaults['providers'],
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

VagrantVirtualBoxProvider.defaults_include(
  'memory' => 4096,
  'cpus' => 2
)

VagrantHyperVProvider.defaults_include(
  'memory' => 4096,
  'cpus' => 2
)

VagrantAzureProvider.defaults_include(
  'size' => 'Standard_B2s'
)
