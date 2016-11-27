# Playground - ASP.NET Core

**Contents** [Overview] | [Usage]  

This folder contains a [multi-machine][VagrantMultiMachine] configuration for quick experiments with ASP.NET Core.

## Overview

This configuration contains the following machines:

Name | Box | Main components
:--- | :--- | :---
windows | [gusztavvargadr/windows10ee] | Windows 10 Enterprise, ASP.NET Core
ubuntu | [ubuntu/trusty64] | Ubuntu 14.04, ASP.NET Core

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up windows
$ vagrant up ubuntu
```

### Sample applications

From the host, connect to the shell of one of the guests:

```
$ vagrant powershell windows
$ vagrant ssh ubuntu
```

Then, from within the guest, you can access the [sample applications' source][src] under `/vagrant/src`.

#### Console application

```
$ cd /vagrant/src/ConsoleApplication
$ dotnet restore
$ dotnet run
```

This will print the home directory of the `vagrant` user according to the guest platform.

#### Web API application

```
$ cd /vagrant/src/WebAPIApplication
$ dotnet restore
$ dotnet run
```

You can access the sample endpoint at the following address according to the platform:

* http://windows.aspnet-core.playground.vagrant.local:5000/api/values
* http://ubuntu.aspnet-core.playground.vagrant.local:5000/api/values

#### Web application

```
$ cd /vagrant/src/WebApplication
$ dotnet restore
$ dotnet run
```

You can access the sample site at the following address according to the platform:

* http://windows.aspnet-core.playground.vagrant.local:5000/
* http://ubuntu.aspnet-core.playground.vagrant.local:5000/

### Code generation

You can access the [Yeoman-based code generation][Yeoman] on both guests:

```
$ yo aspnet
```

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

[Overview]: #overview
[Usage]: #usage

[gusztavvargadr/windows10ee]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee
[ubuntu/trusty64]: https://atlas.hashicorp.com/ubuntu/boxes/trusty64

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[src]: src
[Yeoman]: https://docs.microsoft.com/en-us/aspnet/core/client-side/yeoman

[Samples]: ../../../samples
[YAML]: vagrant.yml
