# Playground - SQL Server

**Contents** [Overview] | [Usage]  

This folder contains a [multi-machine][VagrantMultiMachine] configuration for quick experiments with SQL Server.

## Overview

This configuration contains the following machines:

Name | Box | Main components
:--- | :--- | :---
sql14d-w10e | [gusztavvargadr/windows10ee-sql2014de] | SQL Server 2014 Developer, Windows 10 Enterprise
sql14d-w12r2s | [gusztavvargadr/windows2012r2se-sql2014de] | SQL Server 2014 Developer, Windows Server 2012 R2 Standard

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up sql14d-w10e
$ vagrant up sql14d-w12r2s
```

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

[Overview]: #overview
[Usage]: #usage

[gusztavvargadr/windows10ee-sql2014de]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee-sql2014de
[gusztavvargadr/windows2012r2se-sql2014de]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows2012r2se-sql2014de

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[Samples]: ../../../samples
[YAML]: vagrant.yml
