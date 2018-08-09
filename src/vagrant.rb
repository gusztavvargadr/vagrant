require 'yaml'
require 'erb'

class VagrantDeployment
  @defaults = {
    'environment' => ENV['VAGRANT_DEPLOYMENT_ENVIRONMENT'] || 'vagrant',
    'tenant' => ENV['VAGRANT_DEPLOYMENT_TENANT'] || 'local',
    'hostmanager' => ENV['VAGRANT_DEPLOYMENT_HOSTMANAGER'] == 'true',
    'machines' => {},
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  attr_reader :directory
  attr_reader :options

  attr_reader :vagrant
  attr_reader :machines

  def initialize(directory, options = {})
    @directory = directory
    @options = VagrantDeployment.defaults.deep_merge(options)
    Dir.glob("#{@directory}/vagrant*.yml").sort_by { |file| File.basename(file, '.*') }.each do |file|
      @options = @options.deep_merge(YAML.load(ERB.new(File.read(file)).result) || {})
    end

    @vagrant = nil
    @machines = []
  end

  def configure
    Vagrant.configure('2') do |vagrant|
      @vagrant = vagrant

      configure_core

      yield self if block_given?
    end
  end

  def configure_core
    if hostmanager_enabled?
      vagrant.hostmanager.enabled = true
      vagrant.hostmanager.manage_host = true
      vagrant.hostmanager.manage_guest = false
      # vagrant.hostmanager.ip_resolver = proc do |vm, resolving_vm|
      #   vm.provider.driver.read_guest_ip(1)
      # end
    end

    options.fetch('machines').each do |machine_name, machine_options|
      machine = VagrantMachine.new(self, { 'name' => machine_name }.deep_merge(machine_options))
      machine_count = machine.options.fetch('count')

      if machine_count > 0
        machines.push machine
        machine.configure
      end

      (2..machine_count).each do |machine_index|
        machine = VagrantMachine.new(self, { 'name' => "#{machine_name}-#{machine_index}" }.deep_merge(machine_options))
        machines.push machine
        machine.configure
      end
    end
  end

  def domain
    "#{options.fetch('environment')}.#{options.fetch('tenant')}"
  end

  def hostmanager_enabled?
    options.fetch('hostmanager')
  end
end

class VagrantMachine
  @defaults = {
    'name' => 'default',
    'aliases' => [],
    'box' => '',
    'autostart' => true,
    'primary' => false,
    'providers' => {},
    'no_synced_folders' => ENV['VAGRANT_MACHINE_NO_SYNCED_FOLDERS'] == 'true',
    'synced_folders' => {},
    'provisioners' => {},
    'count' => 1,
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  attr_reader :deployment
  attr_reader :options

  attr_reader :vagrant
  attr_reader :providers
  attr_reader :provisioners

  def initialize(deployment, options = {})
    @deployment = deployment
    @options = VagrantMachine.defaults.deep_merge(options)

    @vagrant = nil
    @providers = []
    @provisioners = []
  end

  def configure
    deployment.vagrant.vm.define options.fetch('name'), vagrant_options do |vagrant|
      @vagrant = vagrant

      configure_core

      yield self if block_given?
    end
  end

  def vagrant_options
    {
      autostart: options.fetch('autostart'),
      primary: options.fetch('primary'),
    }
  end

  def configure_core
    vagrant.vm.box = options['box'] unless options['box'].to_s.empty?

    vagrant.vm.network 'private_network', type: 'dhcp'

    if deployment.hostmanager_enabled?
      vagrant.vm.hostname = hostname
      vagrant.hostmanager.aliases = [fqdn].concat(options.fetch('aliases')).concat(aliases_fqdn) if deployment.hostmanager_enabled?
    end

    options.fetch('providers').each do |provider_name, provider_options|
      provider = nil
      case provider_name
      when 'virtualbox'
        provider = VagrantVirtualBoxProvider.new(self, provider_options)
      when 'hyperv'
        provider = VagrantHyperVProvider.new(self, provider_options)
      else
        raise "Provider '#{provider_name}' is not supported."
      end

      providers.push provider
      provider.configure
    end

    unless options.fetch('no_synced_folders')
      options.fetch('synced_folders').each do |synced_folder_host, synced_folder_guest|
        vagrant.vm.synced_folder synced_folder_host, synced_folder_guest
      end
    end

    options.fetch('provisioners').each do |provisioner_name, provisioner_options|
      provisioner = nil

      provisioner = VagrantShellProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('shell')
      provisioner = VagrantFileProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('file')
      provisioner = VagrantChefPolicyfileProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('chef_policyfile')
      provisioner = VagrantChefZeroProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('chef_zero')
      provisioner = VagrantDockerProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('docker')

      raise "Provisioner '#{provisioner_name}' is not supported." if provisioner.nil?

      provisioners.push provisioner
      provisioner.configure
    end
  end

  def hostname
    options.fetch('name')
  end

  def fqdn
    "#{hostname}.#{deployment.domain}"
  end

  def aliases_fqdn
    options.fetch('aliases').map { |value| "#{value}.#{deployment.domain}" }
  end
end

class VagrantProvider
  @defaults = {
    'type' => '',
    'memory' => 1024,
    'cpus' => 1,
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  attr_reader :machine
  attr_reader :options

  attr_reader :vagrant
  attr_reader :override

  def initialize(machine, options = {})
    @machine = machine
    @options = VagrantProvider.defaults.deep_merge(options)

    @vagrant = nil
    @override = nil
  end

  def configure
    machine.vagrant.vm.provider options.fetch('type') do |vagrant, override|
      @vagrant = vagrant
      @override = override

      configure_core

      yield self if block_given?
    end
  end

  def configure_core
    vagrant.memory = options.fetch('memory')
    vagrant.cpus = options.fetch('cpus')
  end
end

class VagrantVirtualBoxProvider < VagrantProvider
  @defaults = {
    'type' => 'virtualbox',
    'linked_clone' => ENV['VAGRANT_PROVIDER_VIRTUALBOX_LINKED_CLONE'] == 'true',
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  def initialize(machine, options = {})
    super(machine, VagrantVirtualBoxProvider.defaults.deep_merge(options))
  end

  def configure_core
    super

    vagrant.name = machine.fqdn
    vagrant.linked_clone = options.fetch('linked_clone')
  end
end

class VagrantHyperVProvider < VagrantProvider
  @defaults = {
    'type' => 'hyperv',
    'differencing_disk' => ENV['VAGRANT_PROVIDER_HYPERV_DIFFERENCING_DISK'] == 'true',
    'network_bridge' => ENV['VAGRANT_PROVIDER_HYPERV_NETWORK_BRIDGE'].to_s.empty? ? 'Default Switch' : ENV['VAGRANT_PROVIDER_HYPERV_NETWORK_BRIDGE'],
    'smb_username' => ENV['VAGRANT_PROVIDER_HYPERV_SMB_USERNAME'],
    'smb_password' => ENV['VAGRANT_PROVIDER_HYPERV_SMB_PASSWORD'],
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  def initialize(machine, options = {})
    super(machine, VagrantHyperVProvider.defaults.deep_merge(options))
  end

  def configure_core
    super

    override.vm.network 'private_network', bridge: options.fetch('network_bridge')

    # vagrant.memory = [1024, options.fetch('memory')].min
    # vagrant.maxmemory = options.fetch('memory')

    vagrant.vmname = machine.fqdn
    vagrant.differencing_disk = options.fetch('differencing_disk')

    unless machine.options.fetch('no_synced_folders')
      override.vm.synced_folder '.', '/vagrant',
        type: 'smb',
        smb_username: options.fetch('smb_username'),
        smb_password: options.fetch('smb_password')
    end
  end
end

class VagrantProvisioner
  @defaults = {
    'type' => '',
    'run' => '',
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  attr_reader :machine
  attr_reader :name
  attr_reader :options

  attr_reader :vagrant

  def initialize(machine, name, options = {})
    @machine = machine
    @name = name
    @options = VagrantProvisioner.defaults.deep_merge(options)

    @vagrant = nil
  end

  def configure
    machine.vagrant.vm.provision options.fetch('type'), vagrant_options do |vagrant|
      @vagrant = vagrant

      configure_core

      yield self if block_given?
    end
  end

  def vagrant_options
    {
      run: options.fetch('run'),
    }
  end

  def configure_core
  end
end

class VagrantShellProvisioner < VagrantProvisioner
  @defaults = {
    'type' => 'shell',
    'inline' => nil,
    'path' => nil,
    'args' => '',
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  def initialize(machine, name, options = {})
    super(machine, name, VagrantShellProvisioner.defaults.deep_merge(options))
  end

  def vagrant_options
    super.deep_merge(inline: options.fetch('inline'), path: options.fetch('path'), args: options.fetch('args'))
  end
end

class VagrantFileProvisioner < VagrantProvisioner
  @defaults = {
    'type' => 'file',
    'source' => '',
    'destination' => '',
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  def initialize(machine, name, options = {})
    super(machine, name, VagrantFileProvisioner.defaults.deep_merge(options))
  end

  def vagrant_options
    super.deep_merge(source: options.fetch('source'), destination: options.fetch('destination'))
  end
end

class VagrantChefPolicyfileProvisioner < VagrantProvisioner
  @defaults = {
    'type' => 'chef_policyfile',
    'path' => 'Policyfile.rb',
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  def initialize(machine, name, options = {})
    super(machine, name, VagrantChefPolicyfileProvisioner.defaults.deep_merge(options))
  end

  def configure
    machine.vagrant.trigger.before :up, :reload, :provision do |trigger|
      trigger.name = "#{name}_chef_install"
      trigger.run = {
        inline: "chef install #{options.fetch('path')}",
      }
    end

    machine.vagrant.trigger.before :up, :reload, :provision do |trigger|
      trigger.name = "#{name}_chef_export"
      trigger.run = {
        inline: "chef export #{options.fetch('path')} #{machine.deployment.directory}/.chef/#{name} --force",
      }
    end

    machine.vagrant.trigger.before :up, :reload, :provision do |trigger|
      trigger.name = "#{name}_zip"
      trigger.run = {
        inline: "7z a -aoa #{machine.deployment.directory}/.chef/#{name}.zip #{machine.deployment.directory}/.chef/#{name}/",
      }
    end

    file_provisioner = VagrantFileProvisioner.new(
      machine,
      "#{name}_upload",
      'source' => "#{machine.deployment.directory}/.chef/#{name}.zip",
      'destination' => "/tmp/chef/#{name}.zip"
    )
    file_provisioner.configure

    shell_unzip_provisioner = VagrantShellProvisioner.new(
      machine,
      "#{name}_unzip",
      'inline' => "cd /tmp/chef; 7z x -aoa #{name}.zip",
      'run' => options.fetch('run')
    )
    shell_unzip_provisioner.configure

    shell_run_provisioner = VagrantShellProvisioner.new(
      machine,
      "#{name}_chef_run",
      'inline' => "cd /tmp/chef/#{name}; chef-client --local-mode",
      'run' => options.fetch('run')
    )
    shell_run_provisioner.configure
  end
end

class VagrantChefZeroProvisioner < VagrantProvisioner
  @defaults = {
    'type' => 'chef_zero',
    'nodes_path' => ['.vagrant'],
    'cookbooks_path' => ['cookbooks'],
    'run_list' => '',
    'json' => {},
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  def initialize(machine, name, options = {})
    super(machine, name, VagrantChefZeroProvisioner.defaults.deep_merge(options))
  end

  def configure_core
    super

    vagrant.nodes_path = options.fetch('nodes_path')
    vagrant.cookbooks_path = options.fetch('cookbooks_path')
    vagrant.run_list = options.fetch('run_list').split(',')
    vagrant.json = json
  end

  def json
    options.fetch('json')
  end
end

class VagrantDockerProvisioner < VagrantProvisioner
  @defaults = {
    'type' => 'docker',
    'builds' => [],
    'runs' => [],
  }

  def self.defaults(defaults = {})
    @defaults = @defaults.deep_merge(defaults)
  end

  def initialize(machine, name, options = {})
    super(machine, name, VagrantDockerProvisioner.defaults.deep_merge(options))
  end

  def configure_core
    super

    options.fetch('builds').each do |build|
      vagrant.build_image build.fetch('path'), args: build.fetch('args', '')
    end

    options.fetch('runs').each do |run|
      vagrant.run run.fetch('name'),
        image: run.fetch('image', run.fetch('name')),
        args: run.fetch('args', ''),
        cmd: run.fetch('cmd', ''),
        deamonize: run.fetch('daemonize', true),
        restart: run.fetch('restart', 'always')
    end
  end
end

class ::Hash
  def deep_merge(other)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
    self.merge(other.to_h, &merger)
  end
end
