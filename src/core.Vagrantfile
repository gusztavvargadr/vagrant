# ENV["VAGRANT_DEFAULT_PROVIDER"] = ("hyperv" | "virtualbox" | "vmware_desktop")

provider_cpus = ENV["VAGRANT_PROVIDER_CPUS"]
provider_memory = ENV["VAGRANT_PROVIDER_MEMORY"]
provider_nested_virtualization = ENV["VAGRANT_PROVIDER_NESTED_VIRTUALIZATION"] || false
provider_linked_clone = ENV["VAGRANT_PROVIDER_LINKED_CLONE"] || true
provider_synced_folder_disabled = ENV["VAGRANT_PROVIDER_SYNCED_FOLDER_DISABLED"] || true

hyperv_network_bridge = ENV["VAGRANT_HYPERV_NETWORK_BRIDGE"] || "Default Switch"

Vagrant.configure("2") do |config|
  config.vm.provider "hyperv" do |provider, override|
    provider.cpus = provider_cpus unless provider_cpus.to_s.empty?
    provider.memory = provider_memory unless provider_memory.to_s.empty?
    provider.enable_virtualization_extensions = true if provider_nested_virtualization
    provider.linked_clone = provider_linked_clone

    override.vm.network "private_network", bridge: hyperv_network_bridge
  end

  config.vm.provider "virtualbox" do |provider, _override|
    provider.cpus = provider_cpus unless provider_cpus.to_s.empty?
    provider.memory = provider_memory unless provider_memory.to_s.empty?
    provider.customize [ "modifyvm", :id, "--nested-hw-virt", "on" ] if provider_nested_virtualization
    provider.linked_clone = provider_linked_clone
  end

  config.vm.provider "vmware_desktop" do |provider, _override|
    provider.cpus = provider_cpus unless provider_cpus.to_s.empty?
    provider.memory = provider_memory unless provider_memory.to_s.empty?
    provider.vmx["vhv.enable"] = "TRUE" if provider_nested_virtualization
    provider.linked_clone = provider_linked_clone
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true if provider_synced_folder_disabled
end
