require 'yaml'
require 'erb'

Vagrant.require_version('>= 2.1.5')

class VagrantDeployment
  @defaults = {
    'component' => ENV['VAGRANT_DEPLOYMENT_COMPONENT'] || '',
    'service' => ENV['VAGRANT_DEPLOYMENT_SERVICE'] || '',
    'stack' => ENV['VAGRANT_DEPLOYMENT_STACK'] || '',
    'environment' => ENV['VAGRANT_DEPLOYMENT_ENVIRONMENT'] || 'sandbox',
    'tenant' => ENV['VAGRANT_DEPLOYMENT_TENANT'] || 'local',

    'machines' => {
      'defaults' => {},
    },
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
    ['Vagrantfile.yml', 'Vagrantfile.override.yml'].each do |file|
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
    VagrantMachine.defaults_include(options.fetch('machines').fetch('defaults'))
    options.fetch('machines').each do |machine_name, machine_options|
      next if machine_name == 'defaults'

      machine = VagrantMachine.new(self, machine_options.deep_merge('name' => machine_name))
      machine_count = machine.options.fetch('count')

      if machine_count > 0
        machines.push(machine)
        machine.configure
      end

      (2..machine_count).each do |machine_index|
        machine = VagrantMachine.new(self, machine_options.deep_merge('name' => "#{machine_name}-#{machine_index}"))
        machines.push(machine)
        machine.configure
      end
    end
  end

  def domain
    [
      options.fetch('component'),
      options.fetch('service'),
      options.fetch('stack'),
      options.fetch('environment'),
      options.fetch('tenant'),
    ].reject(&:empty?).join('.')
  end
end

class VagrantMachine
  @defaults = {
    'name' => 'default',
    'box' => '',
    'autostart' => true,
    'primary' => false,
    'communicator' => '',
    'count' => 1,
    'providers' => {
      'defaults' => {},
    },
    'synced_folders' => {
      '/vagrant' => {
        'source' => '.',
      },
    },
    'provisioners' => {},
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
    box = options['box']
    unless box.empty?
      box_parts = box.split(':')
      vagrant.vm.box = box_parts[0]
      vagrant.vm.box_version = box_parts[1] unless box_parts.length == 1
    end

    vagrant.vm.communicator = options['communicator'] unless options['communicator'].empty?

    VagrantProvider.defaults_include(options.fetch('providers').fetch('defaults'))
    options.fetch('providers').each do |provider_name, provider_options|
      next if provider_name == 'defaults'

      provider = nil
      case provider_name
      when 'virtualbox'
        provider = VagrantVirtualBoxProvider.new(self, provider_options)
      when 'hyperv'
        provider = VagrantHyperVProvider.new(self, provider_options)
      when 'azure'
        provider = VagrantAzureProvider.new(self, provider_options)
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
      provisioner = VagrantDockerProvisioner.new(self, provisioner_name, provisioner_options) if provisioner_name.start_with?('docker')

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
end

class VagrantProvider
  @defaults = {
    'type' => '',
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
    'memory' => 1024,
    'cpus' => 1,
    'linked_clone' => ENV['VAGRANT_PROVIDER_VIRTUALBOX_LINKED_CLONE'] == 'true',
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

    # vagrant.name = machine.fqdn

    vagrant.memory = options.fetch('memory')
    vagrant.cpus = options.fetch('cpus')
    vagrant.linked_clone = options.fetch('linked_clone')
  end
end

class VagrantHyperVProvider < VagrantProvider
  @defaults = {
    'type' => 'hyperv',
    'memory' => 1024,
    'cpus' => 1,
    'linked_clone' => ENV['VAGRANT_PROVIDER_HYPERV_LINKED_CLONE'] == 'true',
    'start' => ENV['VAGRANT_PROVIDER_HYPERV_START'] || 'Nothing',
    'stop' => ENV['VAGRANT_PROVIDER_HYPERV_STOP'] || 'ShutDown',
    'virtualization' => ENV['VAGRANT_PROVIDER_HYPERV_VIRTUALIZATION'] == 'true',
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

    # vagrant.vmname = machine.fqdn

    vagrant.memory = options.fetch('memory')
    vagrant.cpus = options.fetch('cpus')
    vagrant.linked_clone = options.fetch('linked_clone')

    vagrant.auto_start_action = options.fetch('start')
    vagrant.auto_stop_action = options.fetch('stop')
    vagrant.enable_virtualization_extensions = options.fetch('virtualization')

    override.vm.network 'private_network', bridge: options.fetch('network_bridge')
  end
end

class VagrantAzureProvider < VagrantProvider
  @defaults = {
    'type' => 'azure',
    'box_override' => 'dummy',
    'image_urn' => '',
    'managed_image_id' => '',
    'size' => 'Standard_B1s',
    'location' => ENV['VAGRANT_PROVIDER_AZURE_LOCATION'] || '',
    'synced_folder_type' => 'rsync',
    'ssh_private_key_path_override' => ENV['VAGRANT_PROVIDER_AZURE_SSH_PRIVATE_KEY_PATH_OVERRIDE'] || '',
  }

  class << self
    attr_reader :defaults

    def defaults_include(defaults)
      @defaults = @defaults.deep_merge(defaults)
    end

    def configure(machine, options = {}, &block)
      provider = VagrantAzureProvider.new(machine, options)
      provider.configure(&block)
    end
  end

  def initialize(machine, options = {})
    super(machine, VagrantAzureProvider.defaults.deep_merge(options))
  end

  def configure_core
    super

    # vagrant.vm_name = machine.hostname

    box_override = options.fetch('box_override')
    override.vm.box = box_override unless box_override.empty?

    managed_image_id = options.fetch('managed_image_id')
    if managed_image_id.empty?
      image_urn = options.fetch('image_urn')
      vagrant.vm_image_urn = image_urn unless image_urn.empty?
    else
      vagrant.vm_managed_image_id = managed_image_id 
    end

    vagrant.vm_size = options.fetch('size')

    vagrant.location = options.fetch('location')

    resource_group_name = machine.deployment.domain
    vagrant.resource_group_name = resource_group_name

    vagrant.virtual_network_name = resource_group_name
    vagrant.dns_name = "#{machine.hostname}-#{Digest::MD5.hexdigest(machine.deployment.domain)}"
    vagrant.subnet_name = resource_group_name
    vagrant.nsg_name = resource_group_name

    ssh_private_key_path_override = options.fetch('ssh_private_key_path_override')
    override.ssh.private_key_path = ssh_private_key_path_override unless ssh_private_key_path_override.empty?
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
    'env' => {},
    'reset' => false,
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
    super.deep_merge(
      inline: options.fetch('inline'),
      path: options.fetch('path'),
      args: options.fetch('args'),
      env: options.fetch('env'),
      reset: options.fetch('reset')
    )
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
    'paths' => [],
    'reset' => false,
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
    options.fetch('paths').each do |path|
      policyfile_path = path
      policyfile_digest = Digest::MD5.hexdigest(policyfile_path)

      host_base_path = "#{machine.deployment.directory}/.chef"
      host_directory_path = "#{host_base_path}/#{policyfile_digest}"
      host_file_path = "#{host_directory_path}.zip"

      guest_base_path = '/tmp/chef'
      guest_directory_path = "#{guest_base_path}/#{policyfile_digest}"
      guest_file_path = "#{guest_directory_path}.zip"

      trigger_actions = (File.exist?(host_file_path) && File.size(host_file_path) > 0) ? [:provision] : [:up, :provision]

      FileUtils.mkdir_p File.dirname(host_file_path)
      FileUtils.touch host_file_path

      machine.vagrant.trigger.before trigger_actions do |trigger|
        trigger.name = "#{name}_chef_install"
        trigger.run = {
          inline: "chef install #{policyfile_path}",
        }
      end

      machine.vagrant.trigger.before trigger_actions do |trigger|
        trigger.name = "#{name}_chef_export"
        trigger.run = {
          inline: "chef export #{policyfile_path} #{host_directory_path} --force",
        }
      end

      machine.vagrant.trigger.before trigger_actions do |trigger|
        trigger.name = "#{name}_zip"
        trigger.run = {
          inline: "rm #{host_file_path}; 7z a -sdel #{host_file_path} #{host_directory_path}",
        }
      end

      file_provisioner = VagrantFileProvisioner.new(
        machine,
        "#{name}_upload",
        'source' => host_file_path,
        'destination' => guest_file_path
      )
      file_provisioner.configure

      shell_unzip_provisioner = VagrantShellProvisioner.new(
        machine,
        "#{name}_unzip",
        'inline' => "cd #{guest_base_path}; 7z x -aoa #{guest_file_path}",
        'run' => options.fetch('run')
      )
      shell_unzip_provisioner.configure

      shell_chef_client_provisioner = VagrantShellProvisioner.new(
        machine,
        "#{name}_chef_client",
        'inline' => "cd #{guest_directory_path}; chef-client --local-mode",
        'env' => { 'CHEF_LICENSE' => 'accept-silent' },
        'run' => options.fetch('run'),
        'reset' => options.fetch('reset')
      )
      shell_chef_client_provisioner.configure
    end
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
      vagrant.pull_images run.fetch('image', run.fetch('name'))

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
