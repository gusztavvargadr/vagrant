# Vagrant

**Quick links** [Playground] | [Workstations] | [Samples] | [Boxes] | [Packer templates]  
**Contents** [Overview] | [Getting started] | [Usage] | [Contributing] | [Resources]  

This repository contains [Vagrant] environments using [VirtualBox] for .NET development purposes.

If you are interested in building your own Vagrant boxes instead, check out the [Packer templates] repo.

[Packer templates]: https://github.com/gusztavvargadr/packer

## Overview

> Vagrant up is the new make build.  
[@choult]

Vagrant is a tool for managing (virtual) development environments. By abstracting the management of virtual machines, it provides a way to consistently set up single or multi-machine environments in a hosting-agnostic way. Just type `vagrant up` and have the same setup ready in minutes anywhere. See [the official introduction][VagrantWhy] for more details and usage scenarios.

[Overview]: #overview
[@choult]: https://twitter.com/choult/status/693126220855250944
[VagrantWhy]: https://www.vagrantup.com/docs/why-vagrant/

## Getting started

Follow these steps to get started:

1. Install [Vagrant][VagrantInstallation] and the following plugins:
    1. [Berkshelf][VagrantBerkshelfInstallation].
    2. [Host Manager][VagrantHostManagerInstallation].
    3. [Reload][VagrantReloadInstallation].
2. Install [VirtualBox][VirtualBoxInstallation].
3. Install the [Chef Development Kit][ChefDKInstallation].
4. Disable virtualization platforms other than VirtualBox. On Windows, [disable Hyper-V][HyperVDisable], in case it is running.

These might have been the last few occasions you configured something manually, Vagrant will take care of the rest.

[Getting started]: #getting-started
[VagrantInstallation]: https://www.vagrantup.com/docs/installation/
[VagrantBerkshelfInstallation]: https://github.com/berkshelf/vagrant-berkshelf#installation
[VagrantHostManagerInstallation]: https://github.com/devopsgroup-io/vagrant-hostmanager#installation
[VagrantReloadInstallation]: https://github.com/aidanns/vagrant-reload#installation
[VirtualBoxInstallation]: https://www.virtualbox.org/wiki/Downloads
[ChefDKInstallation]: https://downloads.chef.io/chef-dk/
[HyperVDisable]: https://blogs.technet.microsoft.com/gmarchetti/2008/12/07/turning-hyper-v-on-and-off/

## Usage

If you are not familiar with Vagrant yet, check out [the official guide][VagrantGettingStarted] for an introduction, and the [command-line reference][VagrantCli] for more details.

Then, according to your scenario, give one of the following configurations a try:

* [Playground] for quick experiments in isolation.
* [Workstations] for setting up your everyday development environment.

Of course, the above setups are not the only way to configure your environments. Here are some options to tune them for your needs:

* If you need small or temporary changes (e.g. change the available resources, install additional packages) for any of the above enviroments' machines, you can simply change the related configuration values. See the environments' pages for the available options.
* If you need completely different environments (e.g. set up a deployment environment for your project), you can simply reuse the custom [boxes] and build whatever configurations you like. See the [samples] for the most common scenarios.

[Usage]: #usage
[VagrantGettingStarted]: https://www.vagrantup.com/docs/getting-started/
[VagrantCli]: https://www.vagrantup.com/docs/cli/
[Playground]: src/playground
[Workstations]: src/workstations
[Samples]: samples
[Boxes]: https://atlas.hashicorp.com/gusztavvargadr

## Contributing

Any feedback, [issues] or [pull requests] are welcome and greatly appreciated.

[Contributing]: #contributing
[Issues]: https://github.com/gusztavvargadr/vagrant/issues
[Pull requests]: https://github.com/gusztavvargadr/vagrant/pulls

## Resources

This repository could not exist without the following great tools:

* [Vagrant]
* [VirtualBox]
* [Chef]

[Resources]: #resources
[Vagrant]: https://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/
[Chef]: https://www.chef.io/chef/