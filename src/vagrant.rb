require 'yaml'
require 'erb'

Vagrant.require_version('>= 2.1.5')

class VagrantDeployment
  @defaults = {
    'environment' => ENV['VAGRANT_DEPLOYMENT_ENVIRONMENT'] || 'vagrant',
    'tenant' => ENV['VAGRANT_DEPLOYMENT_TENANT'] || 'local',

    'hostmanager' => ENV['VAGRANT_NETWORK_HOSTMANAGER'] == 'true',

    'machines' => {},
  }

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end

    def configure(directory, options = {}, &block)
      deployment = VagrantDeployment.new(directory, options)
      deployment.configure(&block)
    end
  end

  attr_reader :directory
  attr_reader :options

  attr_reader :vagrant
  attr_reader :machines

  def initialize(directory, options = {})
    @directory = directory
    @options = VagrantDeployment.defaults
    ['vagrant.yml', 'vagrant.override.yml'].each do |file|
      yml = File.join(directory, file)
      @options = @options.deep_merge(YAML.load(ERB.new(File.read(yml)).result) || {}) if File.exist?(yml)
    end
    @options = @options.deep_merge(options)

    @vagrant = nil
    @machines = []
  end

  def configure
    Vagrant.configure(vagrant_options) do |vagrant|
      @vagrant = vagrant

      configure_core
      yield self if block_given?
    end
  end

  def vagrant_options
    '2'
  end

  def configure_core
    if hostmanager_enabled?
      vagrant.hostmanager.enabled = true
      vagrant.hostmanager.manage_host = true
      vagrant.hostmanager.manage_guest = true
      vagrant.hostmanager.include_offline = false

      if ENV['VAGRANT_PREFERRED_PROVIDERS'] == 'virtualbox'
        vagrant.hostmanager.ip_resolver = proc do |vm, resolving_vm|
          vm.provider.driver.read_guest_ip(1) if vm.state.id == :running
        end
      end
    end

    VagrantMachine.defaults_include(options.fetch('machines').fetch('defaults', {}))
    options.fetch('machines').each do |machine_name, machine_options|
      next if machine_name == 'defaults'

      machine = VagrantMachine.new(self, { 'name' => machine_name }.deep_merge(machine_options))
      machine_count = machine.options.fetch('count')

      if machine_count > 0
        machines.push(machine)
        machine.configure
      end

      (2..machine_count).each do |machine_index|
        machine = VagrantMachine.new(self, { 'name' => "#{machine_name}-#{machine_index}" }.deep_merge(machine_options))
        machines.push(machine)
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
    'box' => '',
    'autostart' => true,
    'primary' => false,
    'synced_folders' => {
      '/vagrant' => {
        'source' => '.',
      },
    },
    'aliases' => [],
    'providers' => {},
    'provisioners' => {},
    'count' => 1,
  }

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end

    def configure(deployment, options = {}, &block)
      machine = VagrantMachine.new(deployment, options)
      machine.configure(&block)
    end
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
    self
  end

  def vagrant_options
    {
      autostart: options.fetch('autostart'),
      primary: options.fetch('primary'),
    }
  end

  def configure_core
    vagrant.vm.box = options['box'] unless options['box'].to_s.empty?

    if deployment.hostmanager_enabled?
      vagrant.vm.hostname = hostname
      vagrant.hostmanager.aliases = [fqdn].concat(options.fetch('aliases')).concat(aliases_fqdn)

      vagrant.vm.network 'private_network', type: 'dhcp'
    end

    VagrantProvider.defaults_include(options.fetch('providers').fetch('defaults', {}))
    options.fetch('providers').each do |provider_name, provider_options|
      next if provider_name == 'defaults'

      provider = nil
      case provider_name
      when 'virtualbox'
        provider = VagrantVirtualBoxProvider.new(self, provider_options)
      when 'hyperv'
        provider = VagrantHyperVProvider.new(self, provider_options)
      else
        raise "Provider '#{provider_name}' is not supported."
      end

      providers.push(provider)
      provider.configure
    end

    options.fetch('provisioners').each do |provisioner_name, provisioner_options|
      provisioner = nil

      provisioner = VagrantShellProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('shell')
      provisioner = VagrantFileProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('file')
      provisioner = VagrantChefPolicyfileProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('chef_policyfile')
      provisioner = VagrantChefZeroProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('chef_zero')
      provisioner = VagrantDockerProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('docker')
      provisioner = VagrantReloadProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('reload')

      raise "Provisioner '#{provisioner_name}' is not supported." if provisioner.nil?

      provisioners.push(provisioner)
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
    'linked_clone' => ENV['VAGRANT_PROVIDER_LINKED_CLONE'] == 'true',
    'synced_folder_type' => '',
  }

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end

    def configure(machine, options = {}, &block)
      provider = VagrantProvider.new(machine, options)
      provider.configure(&block)
    end
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
    vagrant.linked_clone = options.fetch('linked_clone')

    machine.options.fetch('synced_folders').each do |synced_folder_destination, synced_folder_options|
      synced_folder_source = synced_folder_options.fetch('source')
      synced_folder_create = synced_folder_options.fetch('create', false)
      synced_folder_disabled = synced_folder_options.fetch('disabled', false)
      synced_folder_type = synced_folder_options.fetch('type', options.fetch('synced_folder_type'))

      case synced_folder_type
      when ''
        override.vm.synced_folder synced_folder_source, synced_folder_destination,
          create: synced_folder_create,
          disabled: synced_folder_disabled
      when 'smb'
        smb_username = ENV['VAGRANT_SYNCED_FOLDER_SMB_USERNAME']
        smb_password = ENV['VAGRANT_SYNCED_FOLDER_SMB_PASSWORD']

        override.vm.synced_folder synced_folder_source, synced_folder_destination,
          create: synced_folder_create,
          disabled: synced_folder_disabled,
          type: 'smb',
          smb_username: smb_username,
          smb_password: smb_password
      else
        override.vm.synced_folder synced_folder_source, synced_folder_destination,
          create: synced_folder_create,
          disabled: synced_folder_disabled,
          type: synced_folder_type
      end
    end
  end
end

class VagrantVirtualBoxProvider < VagrantProvider
  @defaults = {
    'type' => 'virtualbox',
  }

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end

    def configure(machine, options = {}, &block)
      provider = VagrantVirtualBoxProvider.new(machine, options)
      provider.configure(&block)
    end
  end

  def initialize(machine, options = {})
    super(machine, VagrantVirtualBoxProvider.defaults.deep_merge(options))
  end

  def configure_core
    super

    vagrant.name = machine.fqdn
  end
end

class VagrantHyperVProvider < VagrantProvider
  @defaults = {
    'type' => 'hyperv',
    'synced_folder_type' => 'smb',
    'network_bridge' => ENV['VAGRANT_PROVIDER_HYPERV_NETWORK_BRIDGE'] || 'Default Switch',
  }

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end

    def configure(machine, options = {}, &block)
      provider = VagrantHyperVProvider.new(machine, options)
      provider.configure(&block)
    end
  end

  def initialize(machine, options = {})
    super(machine, VagrantHyperVProvider.defaults.deep_merge(options))
  end

  def configure_core
    super

    vagrant.vmname = machine.fqdn

    override.vm.network 'private_network', bridge: options.fetch('network_bridge')
  end
end

class VagrantProvisioner
  @defaults = {
    'type' => '',
    'run' => '',
  }

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end

    def configure(machine, options = {}, &block)
      provider = VagrantProvisioner.new(machine, options)
      provider.configure(&block)
    end
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

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end
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

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end
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

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end
  end

  def initialize(machine, name, options = {})
    super(machine, name, VagrantChefPolicyfileProvisioner.defaults.deep_merge(options))
  end

  def configure
    policyfile_path = options.fetch('path')
    export_base_path = "#{machine.deployment.directory}/.chef"
    export_directory_path = "#{export_base_path}/#{policyfile_path}"
    export_file_path = "#{export_base_path}/#{policyfile_path}.zip"
    upload_base_path = '/tmp'

    trigger_actions = File.exist?(export_file_path) ? [:provision] : [:up, :provision]

    machine.vagrant.trigger.before trigger_actions do |trigger|
      trigger.name = "#{name}_chef_install"
      trigger.run = {
        inline: "chef install #{policyfile_path}",
      }
    end

    machine.vagrant.trigger.before trigger_actions do |trigger|
      trigger.name = "#{name}_chef_export"
      trigger.run = {
        inline: "chef export #{policyfile_path} #{export_directory_path} --force",
      }
    end

    machine.vagrant.trigger.before trigger_actions do |trigger|
      trigger.name = "#{name}_zip"
      trigger.run = {
        inline: "7z a -sdel #{export_file_path} #{export_directory_path}",
      }
    end

    file_provisioner = VagrantFileProvisioner.new(
      machine,
      "#{name}_upload",
      'source' => export_base_path,
      'destination' => upload_base_path
    )
    file_provisioner.configure

    shell_unzip_provisioner = VagrantShellProvisioner.new(
      machine,
      "#{name}_unzip",
      'inline' => "cd #{upload_base_path}; 7z x -aoa #{policyfile_path}.zip",
      'run' => options.fetch('run')
    )
    shell_unzip_provisioner.configure

    shell_chef_client_provisioner = VagrantShellProvisioner.new(
      machine,
      "#{name}_chef_client",
      'inline' => "cd #{upload_base_path}/#{policyfile_path}; chef-client --local-mode",
      'run' => options.fetch('run')
    )
    shell_chef_client_provisioner.configure
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

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end
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

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end
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

class VagrantReloadProvisioner < VagrantProvisioner
  @defaults = {
    'type' => 'reload',
  }

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end
  end

  def initialize(machine, name, options = {})
    super(machine, name, VagrantReloadProvisioner.defaults.deep_merge(options))
  end
end

class ::Hash
  def deep_merge(other)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : Array === v1 && Array === v2 ? v1 | v2 : [:undefined, nil, :nil].include?(v2) ? v1 : v2 }
    self.merge(other.to_h, &merger)
  end
end
