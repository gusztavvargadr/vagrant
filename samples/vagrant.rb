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
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_PROVIDER_AZURE_IMAGE_URN_WINDOWS_SERVER'] || 'MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest',
        'managed_image_id' => ENV['VAGRANT_PROVIDER_AZURE_MANAGED_IMAGE_ID_WINDOWS_SERVER'],
      },
    },
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
        'image_urn' => ENV['VAGRANT_PROVIDER_AZURE_IMAGE_URN_LINUX_SERVER'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
        'managed_image_id' => ENV['VAGRANT_PROVIDER_AZURE_MANAGED_IMAGE_ID_LINUX_SERVER'],
      },
    },
  }
end

class VagrantDockerWindowsMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_DOCKER_WINDOWS'] || 'gusztavvargadr/docker-windows',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_PROVIDER_AZURE_IMAGE_URN_DOCKER_WINDOWS'],
        'managed_image_id' => ENV['VAGRANT_PROVIDER_AZURE_MANAGED_IMAGE_ID_DOCKER_WINDOWS'],
      },
    },
  }
end

class VagrantDockerLinuxMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_DOCKER_LINUX'] || 'gusztavvargadr/docker-linux',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_PROVIDER_AZURE_IMAGE_URN_DOCKER_LINUX'],
        'managed_image_id' => ENV['VAGRANT_PROVIDER_AZURE_MANAGED_IMAGE_ID_DOCKER_LINUX'],
      },
    },
  }
end

VagrantDeployment.defaults_include(
  'stack' => 'vagrant',

  'machines' => {
    'windows' => VagrantWindowsServerMachine.defaults,
    'linux' => VagrantLinuxServerMachine.defaults,
  }
)

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
