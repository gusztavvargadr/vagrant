# Playground

**Contents** [Overview] | [Usage]  

This folder contains a [multi-machine][VagrantMultiMachine] configuration for quick experiments with tools or technologies without messing up other environments.

## Overview

This configuration contains the following machines:

Name | Box | Main components
:--- | :--- | :---
w10e | [gusztavvargadr/windows10ee] | Windows10 Enterprise
w12r2s | [gusztavvargadr/windows2012r2se] | Windows Server 2012 R2 Standard
w16s | [jacqinthebox/windowsserver2016] | Windows Server 2016 Standard
u12 | [ubuntu/precise32] | Ubuntu 12
u14 | [ubuntu/trusty64] | Ubuntu 14

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up w10ee
$ vagrant up w2012r2se
$ vagrant up w2016
$ vagrant up u12
$ vagrant up u14
```

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

[Overview]: #overview
[Usage]: #usage

[gusztavvargadr/windows10ee]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows10ee
[gusztavvargadr/windows2012r2se]: https://atlas.hashicorp.com/gusztavvargadr/boxes/windows2012r2se
[jacqinthebox/windowsserver2016]: https://atlas.hashicorp.com/jacqinthebox/boxes/windowsserver2016
[ubuntu/precise32]: https://atlas.hashicorp.com/ubuntu/boxes/precise32
[ubuntu/trusty64]: https://atlas.hashicorp.com/ubuntu/boxes/trusty64

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[Samples]: ../../samples
[YAML]: vagrant.yml
