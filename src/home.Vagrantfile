# ENV["VAGRANT_DEFAULT_PROVIDER"]=("hyperv"|"virtualbox")

synced_folder_disabled = ENV["VAGRANT_SYNCED_FOLDER_DISABLED"] || true

hyperv_private_network_bridge = ENV["VAGRANT_HYPERV_PRIVATE_NETWORK_BRIDGE"] || "Default Switch"
hyperv_synced_folder_username = ENV["VAGRANT_HYPERV_SYNCED_FOLDER_USERNAME"] || ENV["USERNAME"]
hyperv_synced_folder_password = ENV["VAGRANT_HYPERV_SYNCED_FOLDER_PASSWORD"]

Vagrant.configure("2") do |config|
  if synced_folder_disabled
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.provider "hyperv" do |hyperv, override|
    override.vm.network "private_network", bridge: hyperv_private_network_bridge

    unless synced_folder_disabled
      override.vm.synced_folder ".", "/vagrant", type: "smb", smb_username: hyperv_synced_folder_username, smb_password: hyperv_synced_folder_password
    end
  end
end
