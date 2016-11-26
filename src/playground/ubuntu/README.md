# Playground - Ubuntu

**Contents** [Overview] | [Usage]  

This folder contains a [multi-machine][VagrantMultiMachine] configuration for quick experiments with Ubuntu.

## Overview

This configuration contains the following machines:

Name | Box | Main components
:--- | :--- | :---
u12 | [ubuntu/precise64] | Ubuntu 12.04
u14 | [ubuntu/trusty64] | Ubuntu 14.04
u16 | [ubuntu/xenial64] | Ubuntu 16.04

## Usage

None of the machines [start automatically][VagrantAutostart] in this configuration, use the value from the `Name` column above for interacting with them in Vagrant. For example, to boot the machines, type one of the following commands:

```
$ vagrant up u12
$ vagrant up u14
$ vagrant up u16
```

### Customization

You can use the [YAML-based options][Samples] to customize [this configuration][YAML].

[Overview]: #overview
[Usage]: #usage

[ubuntu/precise64]: https://atlas.hashicorp.com/ubuntu/boxes/precise64
[ubuntu/trusty64]: https://atlas.hashicorp.com/ubuntu/boxes/trusty64
[ubuntu/xenial64]: https://atlas.hashicorp.com/ubuntu/boxes/xenial64

[VagrantMultiMachine]: https://www.vagrantup.com/docs/multi-machine/
[VagrantAutostart]: https://www.vagrantup.com/docs/multi-machine/#autostart-machines

[Samples]: ../../../samples
[YAML]: vagrant.yml
