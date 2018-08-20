# Vagrant

<!-- TODOs

cli synced folder
32 bit test
tools folder in root
synced_folders remove 

vagrant
  dynamic registration of deployment / machine / provisioner / provider types
  hyperv dyanmic memory / virt ext
  multiple deployments
    to be able to merge them
    deployment name from parent dir by default
  provider to decide from vagrant instead of env var
  deployment directory from Vagrant
  review tenant / env (add project / stack / component?)
    vagrant: org, domain, component, project, tenant, env
  vagrant factory method extract
  hostmanager into network
  aliases count
  platform-based provisioners
  conventions for configuration / provisioners
  review vagrant options
  scripts for triggers
  include rb files with local yamls instead of pure yaml merging
    defaults in core yaml as well
    overrides per environment to load automatically
  vagrant chef json static vs method
  yml split configurtion for env, vm, provision, etc
  vagrant core : private / public network optins
  virtualbox: ip lookup
  env vars to options
  env name load from folder (check with kitchen)
  machine / provisioner options directly (do not depend on env, other machines)
  default options load from yml
  data files load with chef
  vault
  virtualbox
  dotnet
  double check src / sample count
  0-based index for vagrant also
  docker provider

src
  split vagrant file across core / compute / etc
  vagrant version to conf
  vagrant memory hyperv allow from to
  vagrant multiple deployments in single file?
  core vagrantcomponent / vagrantbuilder
  ruby lint
    factory methods for parents (e.g. deployment.machine instead of VagrantMachine.configure)
    ruby modules / namespaces - sources to e.g. Vagrant from Vagrantfile, Berkshelf from Berksfile
    ruby symbolize keys
    ruby named params instead of options on classes
    ruby blocks to change configuration (similar to core vagrant)
      extract and apply policies instead of pure options
      auto traverse hierarchy?
  rb extensions as vagrant plugin?

samples
  defaults / overrides / count (yaml)
  provider samples
  organize other samples into deployments?
  sample for dhcp server (to be used in hyperv)

docs
  update with samples

-->

<!--
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
-->