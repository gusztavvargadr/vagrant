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
    'box' => ENV['VAGRANT_BOX_WINDOWS_SERVER'] || 'gusztavvargadr/docker-windows',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_PROVIDER_AZURE_IMAGE_URN_WINDOWS_SERVER'] || 'MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest',
        'managed_image_id' => ENV['VAGRANT_PROVIDER_AZURE_MANAGED_IMAGE_ID_WINDOWS_SERVER'] || '',
      },
    },
  }
end

class VagrantLinuxServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_LINUX_SERVER'] || 'gusztavvargadr/docker-linux',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_PROVIDER_AZURE_IMAGE_URN_LINUX_SERVER'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
        'managed_image_id' => ENV['VAGRANT_PROVIDER_AZURE_MANAGED_IMAGE_ID_LINUX_SERVER'] || '',
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
