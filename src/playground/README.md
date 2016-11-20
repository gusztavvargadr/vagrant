# Playground

**Contents** [Overview] | [Usage]  

This folder contains a [multi-machine][VagrantMultiMachine] configuration for quick experiments with tools or technologies without messing up other environments.

## Overview

The configuration contains the following machines:

Name | Box | Main components
:--- | :--- | :---
w10ee | [gusztavvargadr/windows10ee] | Windows10 Enterprise
w2012r2se | [gusztavvargadr/windows2012r2se] | Windows Server 2012 R2 Standard

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up w10ee
$ vagrant up w2012r2se
```

### Customization

[Samples]
[yml]

[Overview]: #overview
[Usage]: #usage

[gusztavvargadr/windows10ee]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee
[gusztavvargadr/windows2012r2se]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows2012r2se

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[Samples]: ../../samples
[yml]: vagrant.yml