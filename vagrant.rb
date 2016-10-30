require 'yaml'
require 'erb'

def vagrant_configure(directory_path)
  settings = load_settings(directory_path)
  Vagrant.configure(2) do |config|
    vagrant_config_hostmanager config, settings
    vagrant_config_vms config, settings
  end
end

def load_settings(directory_path)
  settings = default_settings
  Dir["#{directory_path}/vagrant*.yml"].sort_by { |f| File.basename(f, '.*') }.each do |settings_file_path|
    settings = settings.deep_merge(YAML.load(ERB.new(File.read(settings_file_path)).result))
  end
  settings
end

def default_settings
  {
    'config' => { 'hostmanager' => false },
    'vms' => {
      'default' => {
        'autostart' => true,
        'box' => 'ubuntu/trusty64'
      }
    }
  }
end

def vagrant_config_hostmanager(config, settings)
  config_settings = settings['config']
  config.hostmanager.enabled = config_settings['hostmanager']
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
end

def vagrant_config_vms(config, settings)
  vms_settings = settings['vms']
  default_vm_settings = vms_settings['default']
  settings['vms'].each do |vm_name, vm_settings|
    next if vm_name == 'default' && vms_settings.length > 1
    vm_settings = default_vm_settings.deep_merge(vm_settings)
    vagrant_config_vm_define config, vm_name, vm_settings
  end
end

def vagrant_config_vm_define(config, vm_name, vm_settings)
  config.vm.define vm_name, autostart: vm_settings['autostart'] do |vm_config|
    vagrant_config_vm_box vm_config, vm_settings
    vagrant_config_vm_providers vm_config, vm_settings
    vagrant_config_vm_network vm_config, vm_settings
    vagrant_config_vm_provisioners vm_config, vm_settings
  end
end

def vagrant_config_vm_box(vm_config, vm_settings)
  vm_box = vm_settings['box']
  vm_config.vm.box = vm_box.include?('/') ? vm_box : "gusztavvargadr/#{vm_box}"
end

def vagrant_config_vm_providers(vm_config, vm_settings)
  providers_settings = vm_settings['providers']
  unless providers_settings.nil?
    providers_settings.each do |provider_name, provider_settings|
      if provider_name == 'virtualbox'
        vm_config.vm.provider provider_name do |provider|
          provider.gui = provider_settings['gui']
          provider.memory = provider_settings['memory']
          provider.cpus = provider_settings['cpus']
        end
      end
    end
  end
end

def vagrant_config_vm_network(vm_config, vm_settings)
  network_settings = vm_settings['network']
  unless network_settings.nil?
    if network_settings['ip'].nil?
      vm_config.vm.network network_settings['type'], type: 'dhcp'
    else
      vm_config.vm.network network_settings['type'], ip: network_settings['ip']
    end

    ports = network_settings['ports']
    unless ports.nil?
      network_settings['ports'].each do |port_name, port_settings|
        vm_config.vm.network :forwarded_port, id: port_name, host: port_settings['host'], guest: port_settings['guest'], auto_correct: port_settings['auto_correct']
      end
    end

    hostnames = network_settings['hostnames']
    vm_config.hostmanager.aliases = hostnames unless hostnames.nil?
  end
end

def vagrant_config_vm_provisioners(vm_config, vm_settings)
  provisioners_settings = vm_settings['provisioners']
  unless provisioners_settings.nil?
    provisioners_settings.sort.map.each do |provisioner_name, provisioner_settings|
      provisioner_type = provisioner_settings['type']

      if provisioner_type == 'file'
        vm_config.vm.provision 'file', source: provisioner_settings['source'], destination: provisioner_settings['destination']
      end

      if provisioner_type == 'chef-solo'
        vm_config.vm.provision 'chef_solo' do |chef_solo|
          chef_solo.cookbooks_path = ''
          chef_solo.add_recipe provisioner_settings['recipe']
          json = provisioner_settings['attributes']
          chef_solo.json = json unless json.nil?
        end
      end

      if provisioner_type == 'reload'
        vm_config.vm.provision :reload
      end
    end
  end
end

class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
    self.merge(second.to_h, &merger)
  end
end
