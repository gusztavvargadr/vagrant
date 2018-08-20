directory = File.dirname(__FILE__)

require "#{directory}/../src/vagrant"

VagrantMachine.defaults_include(
  'providers' => {
    'virtualbox' => {},
    'hyperv' => {},
  }
)

class VagrantLinuxServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_LINUX_SERVER'] || 'gusztavvargadr/u16s-dc',
  }
end

class VagrantWindowsServerMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_WINDOWS_SERVER'] || 'gusztavvargadr/w16s-de',
  }
end

class VagrantWindowsDesktopMachine < VagrantMachine
  @defaults = {
    'box' => ENV['VAGRANT_BOX_WINDOWS_DESKTOP'] || 'gusztavvargadr/w10e-dc',
  }
end
