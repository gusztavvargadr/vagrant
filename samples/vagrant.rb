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

class VagrantWindowsMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_WINDOWS'] || 'gusztavvargadr/docker-windows',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_WINDOWS_SERVER_AZURE_IMAGE_URN'] || 'MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_WINDOWS_SERVER_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    }
  )
end

class VagrantLinuxMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_LINUX'] || 'gusztavvargadr/docker-linux',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_LINUX_SERVER_AZURE_IMAGE_URN'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_LINUX_SERVER_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    }
  )
end

VagrantDeployment.defaults_include(
  'stack' => 'vagrant',
  'service' => 'samples',

  'machines' => {
    'windows' => VagrantWindowsMachine.defaults,
    'linux' => VagrantLinuxMachine.defaults,
  }
)
