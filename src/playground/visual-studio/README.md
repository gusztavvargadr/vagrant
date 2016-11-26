# Playground - Visual Studio

**Contents** [Overview] | [Usage]  

This folder contains a [multi-machine][VagrantMultiMachine] configuration for quick experiments with Visual Studio.

## Overview

This configuration contains the following machines:

Name | Box | Main components
:--- | :--- | :---
vs15c | [gusztavvargadr/windows10ee-vs2015c] | Visual Studio 2015 Community
vs15p | [gusztavvargadr/windows10ee-vs2015p] | Visual Studio 2015 Professional
vs10p | [gusztavvargadr/windows10ee-vs2010p] | Visual Studio 2010 Professional
vs10p-vs15p | [gusztavvargadr/windows10ee-vs2010p-vs2015p] | Visual Studio 2010 and 2015 Professional
vs15c-sql | [gusztavvargadr/windows10ee-sql2014de-vs2015c] | Visual Studio 2015 Community, SQL Server 2014 Developer
vs15p-sql | [gusztavvargadr/windows10ee-sql2014de-vs2015p] | Visual Studio 2015 Professional, SQL Server 2014 Developer
vs10p-sql | [gusztavvargadr/windows10ee-sql2014de-vs2010p] | Visual Studio 2010 Professional, SQL Server 2014 Developer
vs10p-vs15p-sql | [gusztavvargadr/windows10ee-sql2014de-vs2010p-vs2015p] | Visual Studio 2010 and 2015 Professional, SQL Server 2014 Developer

All the above are based on Windows 10 Enterprise.

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up vs15c
$ vagrant up vs15p
$ vagrant up vs10p
$ vagrant up vs10p-vs15p
$ vagrant up vs15c-sql
$ vagrant up vs15p-sql
$ vagrant up vs10p-sql
$ vagrant up vs10p-vs15p-sql
```

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

[Overview]: #overview
[Usage]: #usage

[gusztavvargadr/windows10ee-vs2015c]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-vs2015c
[gusztavvargadr/windows10ee-vs2015p]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-vs2015p
[gusztavvargadr/windows10ee-vs2010p]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-vs2010p
[gusztavvargadr/windows10ee-vs2010p-vs2015p]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-vs2010p-vs2015p
[gusztavvargadr/windows10ee-sql2014de-vs2015c]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-sql2014de-vs2015c
[gusztavvargadr/windows10ee-sql2014de-vs2015p]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-sql2014de-vs2015p
[gusztavvargadr/windows10ee-sql2014de-vs2010p]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-sql2014de-vs2010p
[gusztavvargadr/windows10ee-sql2014de-vs2010p-vs2015p]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-sql2014de-vs2010p-vs2015p

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[Samples]: ../../../samples
[YAML]: vagrant.yml
