directory = File.dirname(__FILE__)

require "#{directory}/../src/vagrant"

class VagrantWindowsServerMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_WINDOWS_SERVER'] || 'gusztavvargadr/windows-server',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_WINDOWS_SERVER_AZURE_IMAGE_URN'] || 'MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_WINDOWS_SERVER_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    }
  )
end

class VagrantLinuxServerMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_LINUX_SERVER'] || 'gusztavvargadr/ubuntu-server',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_LINUX_SERVER_AZURE_IMAGE_URN'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_LINUX_SERVER_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    }
  )
end

class VagrantDockerWindowsMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_DOCKER_WINDOWS'] || 'gusztavvargadr/docker-windows',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_DOCKER_WINDOWS_AZURE_IMAGE_URN'] || 'MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_DOCKER_WINDOWS_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    }
  )
end

class VagrantDockerLinuxMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_DOCKER_LINUX'] || 'gusztavvargadr/docker-linux',
    'providers' => {
      'azure' => {
        'image_urn' => ENV['VAGRANT_BOX_DOCKER_LINUX_AZURE_IMAGE_URN'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_DOCKER_LINUX_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    }
  )
end
