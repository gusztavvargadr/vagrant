# Vagrant

<!-- TODOs
migrate todos

src core / providers / ...
mount options only for smb
samples with defaults / overrides / count (yaml)
update docs
vagrant defaults into each class
vagrant version to conf
vagrant MULTIPLE deployments in single file?
vagrant environment to name stack service (component) env local
ruby modules / namespaces - sources to e.g. Vagrant from Vagrantfile, Berkshelf from Berksfile
check with vbox
hostmanager check (dhcp network - check with vbox)
back to private networks
core vagrantcomponent / vagrantbuilder
split vagrant file across core / compute / etc
vagrant option to set hostname (e.g. clusters)
vagrant memory hyperv allow from to
yaml version / document separator
rb extensions as vagrant plugin?
vagrant berkshelf eliminate
vagrant yml remove duplication
-->

**Quick links** [Vagrant resources] | [Virtual workstations] | [Vagrant boxes] | [Packer templates]  

[This repository][Vagrant resources] serves as the as starting point for the following [Vagrant] resources for virtualized .NET development on Windows with Hyper-V and VirtualBox:

* [Virtual workstations]
* [Vagrant boxes]
* [Packer templates]

Please follow the links above for more information.

[Vagrant]: https://www.vagrantup.com/

[Vagrant resources]: https://github.com/gusztavvargadr/vagrant
[Virtual workstations]: https://github.com/gusztavvargadr/workstations
[Vagrant boxes]: https://atlas.hashicorp.com/gusztavvargadr
[Packer templates]: https://github.com/gusztavvargadr/packer

**Note** The earlier approach of a single repository supporting all the different types of Vagrant environments is now deprecated and is no longer being maintained. You can find the latest version of that approach [here][Deprecated].

[Deprecated]: https://github.com/gusztavvargadr/vagrant/tree/0.1.0
