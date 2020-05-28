class VagrantWindowsServerMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_WINDOWS_SERVER'] || 'gusztavvargadr/windows-server',
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
        'image_urn' => ENV['VAGRANT_BOX_LINUX_SERVER_AZURE_IMAGE_URN'] || 'Canonical:UbuntuServer:16.04-LTS:latest',
        'managed_image_id' => ENV['VAGRANT_BOX_LINUX_SERVER_AZURE_MANAGED_IMAGE_ID'] || '',
      },
    }
  )
end

class VagrantWindowsDesktopMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_WINDOWS_DESKTOP'] || 'gusztavvargadr/windows-10',
    'providers' => {
      'virtualbox' => {
        'memory' => 4096,
        'cpus' => 2,
      },
      'hyperv' => {
        'memory' => 4096,
        'cpus' => 2,
      },
      'azure' => {
        'size' => 'Standard_B2s',
      },
    }
  )
end

class VagrantLinuxDesktopMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_LINUX_DESKTOP'] || 'gusztavvargadr/ubuntu-desktop',
    'providers' => {
      'virtualbox' => {
        'memory' => 4096,
        'cpus' => 2,
      },
      'hyperv' => {
        'memory' => 4096,
        'cpus' => 2,
      },
      'azure' => {
        'size' => 'Standard_B2s',
      },
    }
  )
end

class VagrantWindowsDockerMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_WINDOWS_DOCKER'] || 'gusztavvargadr/docker-windows',
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
end

class VagrantLinuxDockerMachine < VagrantMachine
  @defaults = VagrantMachine.defaults.deep_merge(
    'box' => ENV['VAGRANT_BOX_LINUX_DOCKER'] || 'gusztavvargadr/docker-linux',
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
end
