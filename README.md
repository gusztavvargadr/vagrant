# Vagrant

<!-- TODOs

https://www.vagrantup.com/docs/vagrantfile/vagrant_version.html
include rb files with local yamls instead of pure yaml merging
config include yaml files from multiple dirs
  local rb files to process local yaml
  defaults in core yaml as well
  overrides per environment to load automatically

single samples with all provisioners
meta repo, contributing or setup script to update references
naming: underscore vs hyphen
conventions for configuration / provisioners
default boxes per scenario based on env with default
review options
windows chef node issues
common settings for providers - linked_clone, gui

general
  terraform for local config
  multiple domain names per level with overrides to support aliases too
  terraform / packer "deployment" with docker
  providers / platform as params for e.g. docker 
  separate provisioning samples from machine / container
  ci flow
  environment generalization with providers (vagrant, terraform)
  contributing.ps1
  license.md
  core repo with common components

vagrant
  vagrant: org, domain, component, project, tenant, env
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


core
  migrate todos from other repose

src
  hostmanager check (dhcp network - check with vbox)
  split vagrant file across core / compute / etc
  vagrant version to conf
  vagrant memory hyperv allow from to
  vagrant multiple deployments in single file?
  vagrant environment to name stack service (component) env local
  ruby modules / namespaces - sources to e.g. Vagrant from Vagrantfile, Berkshelf from Berksfile
  core vagrantcomponent / vagrantbuilder
  yaml version / document separator
  vagrant option to set hostname (e.g. clusters)
  vagrant berkshelf eliminate -> policyfile
  vagrant yml reuse
  rb extensions as vagrant plugin?
  default boxes for platform / feature (e.g. linux / windows, docker, etc)

samples
  defaults / overrides / count (yaml)

docs
  update with samples

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
