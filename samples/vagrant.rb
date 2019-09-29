directory = File.dirname(__FILE__)

require "#{directory}/../src/vagrant"

VagrantMachine.defaults_include(
  'providers' => {
    'virtualbox' => {
      'memory' => 1024,
      'cpus' => 1,
    },
    'hyperv' => {
      'memory' => 1024,
      'cpus' => 1,
    },
    'azure' => {
      'size' => 'Standard_B1s',
    },
  }
)

class VagrantWindowsServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_WINDOWS_SERVER'] || 'gusztavvargadr/windows-server',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_WINDOWS_SERVER_AZURE_IMAGE_URN'] || 'MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_WINDOWS_SERVER_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    },
  }
end

class VagrantLinuxServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_LINUX_SERVER'] || 'gusztavvargadr/ubuntu-server',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_LINUX_SERVER_AZURE_IMAGE_URN'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_LINUX_SERVER_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    },
  }
end

class VagrantDockerWindowsMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_DOCKER_WINDOWS'] || 'gusztavvargadr/docker-windows',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_DOCKER_WINDOWS_AZURE_IMAGE_URN'] || 'MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_DOCKER_WINDOWS_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    },
  }
end

class VagrantDockerLinuxMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_LINUX_SERVER'] || 'gusztavvargadr/docker-linux',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_DOCKER_LINUX_AZURE_IMAGE_URN'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_DOCKER_LINUX_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    },
  }
end

VagrantDeployment.defaults_include(
  'stack' => 'vagrant',
  'service' => 'samples',

  'machines' => {
    'windows' => VagrantWindowsServerMachine.defaults,
    'linux' => VagrantLinuxServerMachine.defaults,
  }
)
