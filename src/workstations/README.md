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

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up dotnet
$ vagrant up sql
$ vagrant up chef
```

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

[Overview]: #overview
[Usage]: #usage

[gusztavvargadr/windows10ee-vs2015c]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-vs2015c
[gusztavvargadr/windows10ee-sql2014de]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-sql2014de
[gusztavvargadr/windows10ee]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[Samples]: ../../samples
[YAML]: vagrant.yml
