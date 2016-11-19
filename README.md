# Vagrant

**Quick links** [Playground] | [Workstations] | [Boxes]  
**Contents** [Overview] | [Getting started] | [Usage] | [Resources]  

This repository contains [Vagrant] environments using [VirtualBox] for .NET development purposes.

## Overview

> Vagrant up is the new make build.  
[@choult]

Vagrant is a tool for managing development environments. By abstracting the management of virtual machines and their configurations, it provides a way to consistently set up simple machines or complex environments independently of the hosting platform. See [the official introduction][VagrantWhy] for more details.

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

[Getting started]: #getting-started
[VagrantInstallation]: https://www.vagrantup.com/docs/installation/
[VagrantBerkshelfInstallation]: https://github.com/berkshelf/vagrant-berkshelf#installation
[VagrantHostManagerInstallation]: https://github.com/devopsgroup-io/vagrant-hostmanager#installation
[VagrantReloadInstallation]: https://github.com/aidanns/vagrant-reload#installation
[VirtualBoxInstallation]: https://www.virtualbox.org/wiki/Downloads
[ChefDKInstallation]: https://downloads.chef.io/chef-dk/
[HyperVDisable]: https://blogs.technet.microsoft.com/gmarchetti/2008/12/07/turning-hyper-v-on-and-off/

## Usage

Check out [Vagrant's official guide][VagrantGettingStarted] for an introduction and the [command-line reference][VagrantCli] for more details.

[Usage]: #usage
[VagrantGettingStarted]: https://www.vagrantup.com/docs/getting-started/
[VagrantCli]: https://www.vagrantup.com/docs/cli/

### Environments

The repository contains the following environments:

* [Playground] for quick experiments.
* [Workstations] for the everday development tasks.

[Playground]: src/playground
[Workstations]: src/workstations

### Customization

The above environments use [custom YAML-based configuration][YAML] for easy setup and customization. See the individual environments' description for a complete list of options.

You can also build your own configurations and environments using the custom [boxes].

[YAML]: src/samples
[Boxes]: https://github.com/gusztavvargadr/packer

## Resources

This repository could not exist without the following great tools:

* [Vagrant]
* [VirtualBox]
* [Chef]

[Resources]: #resources
[Vagrant]: https://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/
[Chef]: https://www.chef.io/chef/