# Workstations

**Contents** [Overview] | [Usage]  

This folder contains a [multi-machine][VagrantMultiMachine] configuration for setting up your development workstation(s) for everyday tasks.

## Overview

This configuration contains the following machines:

Name | Box | Main components
:--- | :--- | :---
dotnet | [gusztavvargadr/windows10ee-vs2015c] | Windows 10 Enterprise, Visual Studio 2015 Community
sql | [gusztavvargadr/windows10ee-sql2014de] | Windows 10 Enterprise, SQL Server 2014 Developer
chef | [gusztavvargadr/windows10ee] | Windows 10 Enterprise, Chef Development Kit

All the machines are provisioned by default as below:

* Copy your global `.gitconfig` from the host to the guest
* Install a customizable list of Chocolatey packages
  * By default [git] and [git-credential-manager-for-windows]
* Clone a customizable list of Git repositories
  * By default [github/gitignore]

[git]: https://chocolatey.org/packages/git
[git-credential-manager-for-windows]: https://chocolatey.org/packages/Git-Credential-Manager-for-Windows
[github/gitignore]: https://github.com/github/gitignore

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up dotnet
$ vagrant up sql
$ vagrant up chef
```

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

#### Chocolatey packages

Extend the following section of [the configuration][YAML] to install additional packages:

```yaml
vms:
  <name>:
    provisioners:
      10-chef-solo-chocolatey-packages:
        attributes:
          gusztavvargadr_vagrant:
            chocolatey_packages:
              # Install the latest version of the package with the default options
              nuget.commandline:
              # Install the specific version of the package with custom options
              git:
                version: 2.10.2
                options: -params '"/GitAndUnixToolsOnPath"'
```

#### Git repositories

Extend the following section of [the configuration][YAML] to clone additional repositories:

```yaml
vms:
  <name>:
    provisioners:
      30-chef-solo-git-profiles:
        attributes:
          gusztavvargadr_vagrant:
            git_profiles:
              # Base url for all the repositories in this "profile" (you can define multiple ones)
              # You can specify your credentials in the url like https://username:password@github.com for private repos
              https://github.com:
                # Base directory path for the clones
                checkout_directory_path: /Users/vagrant/Repos
                repositories:
                  # Will be cloned to the default /Users/vagrant/Repos/github/gitignore directory
                  github/gitignore:
                  # Will be cloned to the custom /dotnet-home directory
                  dotnet/home:
                    checkout_directory_path: /dotnet-home
```

[Overview]: #overview
[Usage]: #usage

[gusztavvargadr/windows10ee-vs2015c]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-vs2015c
[gusztavvargadr/windows10ee-sql2014de]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-sql2014de
[gusztavvargadr/windows10ee]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[Samples]: ../../samples
[YAML]: vagrant.yml
