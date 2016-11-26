# Playground - IIS

**Contents** [Overview] | [Usage]  

This folder contains a [multi-machine][VagrantMultiMachine] configuration for quick experiments with IIS.

## Overview

This configuration contains the following machines:

Name | Box | Main components
:--- | :--- | :---
iis | [gusztavvargadr/windows2012r2se-iis] | IIS 8.5
iis-sql | [gusztavvargadr/windows2012r2se-sql2014de-iis] | IIS 8.5, SQL Server 2014 Developer

All the above are based on Windows Server 2012 R2 Standard.

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up iis
$ vagrant up iis-sql
```

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

[Overview]: #overview
[Usage]: #usage

[gusztavvargadr/windows2012r2se-iis]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows2012r2se-iis
[gusztavvargadr/windows2012r2se-sql2014de-iis]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows2012r2se-sql2014de-iis

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[Samples]: ../../../samples
[YAML]: vagrant.yml
