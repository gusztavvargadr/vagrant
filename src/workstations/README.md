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
* Windows
  * Install a customizable list of features
  * Install a customizable list of packages
  * Install a customizable list of Chocolatey packages
    * By default [git], [git-credential-manager-for-windows], [svn] and [nuget.commandline]
* Profiles
  * Clone a customizable list of Git repositories
    * By default [github/gitignore]
  * Check out a customizable list of SVN repositories
  * Configure a customizable list of NuGet feeds

[Overview]: #overview
[gusztavvargadr/windows10ee-vs2015c]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-vs2015c
[gusztavvargadr/windows10ee-sql2014de]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-sql2014de
[gusztavvargadr/windows10ee]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee
[git]: https://chocolatey.org/packages/git
[git-credential-manager-for-windows]: https://chocolatey.org/packages/Git-Credential-Manager-for-Windows
[svn]: https://chocolatey.org/packages/svn
[nuget.commandline]: https://chocolatey.org/packages/nuget.commandline
[github/gitignore]: https://github.com/github/gitignore

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up dotnet
$ vagrant up sql
$ vagrant up chef
```

[Usage]: #usage
[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

[Samples]: ../../samples
[YAML]: vagrant.yml

#### Windows

##### Features

Extend the following section of [the configuration][YAML] to install additional [Windows features]:

```yaml
vms:
  <name>:
    provisioners:
      10-chef-solo-windows:
        attributes:
          gusztavvargadr_windows:
            features:
              - TelnetClient
```

[Windows features]: https://visualplanet.org/blog/?p=342

##### Packages

Extend the following section of [the configuration][YAML] to install additional Windows packages:

```yaml
vms:
  <name>:
    provisioners:
      10-chef-solo-windows:
        attributes:
          gusztavvargadr_windows:
            packages:
              Redgate DLM Automation Suite:
                source: https://download.red-gate.com/DLMAutomationSuite.exe
                options: /IAgreeToTheEULA /q
```

##### Chocolatey packages

Extend the following section of [the configuration][YAML] to install additional [Chocolatey packages]:

```yaml
vms:
  <name>:
    provisioners:
      10-chef-solo-windows:
        attributes:
          gusztavvargadr_windows:
            chocolatey_packages:
              # Install the latest version of the package with the default options
              nuget.commandline:
              # Install the specific version of the package with custom options
              git:
                version: 2.10.2
                options: -params '"/GitAndUnixToolsOnPath"'
```

[Chocolatey packages]: https://chocolatey.org/packages

#### Profiles

##### Git

Extend the following section of [the configuration][YAML] to clone additional Git repositories:

```yaml
vms:
  <name>:
    provisioners:
      30-chef-solo-profiles:
        attributes:
          gusztavvargadr_git:
            profiles:
              # Base url for all the repositories in this "profile" (you can define multiple ones)
              https://github.com:
                # Optionally, specify your credentials for private repos
                username: <%= ENV['GIT_GITHUB_USERNAME'] %>
                password: <%= ENV['GIT_GITHUB_PASSWORD'] %>
                # Base directory path for the clones
                checkout_directory_path: /Users/vagrant/Repos
                repositories:
                  # Will be cloned to the default /Users/vagrant/Repos/github/gitignore directory
                  github/gitignore:
                  # Will be cloned to the custom /dotnet-home directory
                  dotnet/home:
                    checkout_directory_path: /dotnet-home
```

##### SVN

Extend the following section of [the configuration][YAML] to check out additional SVN repositories:

```yaml
vms:
  <name>:
    provisioners:
      30-chef-solo-profiles:
        attributes:
          gusztavvargadr_svn:
            profiles:
              # Base url for all the repositories in this "profile" (you can define multiple ones)
              http://svn.apache.org/repos:
                # Optionally, specify your credentials for private repos
                username: <%= ENV['SVN_USERNAME'] %>
                password: <%= ENV['SVN_PASSWORD'] %>
                # Base directory path for the checkouts
                checkout_directory_path: /Users/vagrant/Repos
                repositories:
                  # Will be checked out to the default /Users/vagrant/Repos/asf/logging/log4net/trunk directory
                  asf/logging/log4net/trunk:
                  # Will be checked out to the custom /log4net directory
                  asf/logging/log4net/trunk:
                    checkout_directory_path: /log4net
```

##### NuGet

Extend the following section of [the configuration][YAML] to configure additional NuGet feeds:

```yaml
vms:
  <name>:
    provisioners:
      30-chef-solo-profiles:
        attributes:
          gusztavvargadr_nuget:
            profiles:
              # Feed url (you can define multiple ones)
              https://www.myget.org/F/identity/:
                # Optionally, specify a name for the feed
                name: myget-identity
                # Optionally, specify your credentials for private feeds
                username: <%= ENV['SVN_USERNAME'] %>
                password: <%= ENV['SVN_PASSWORD'] %>
```
