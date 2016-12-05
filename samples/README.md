# Samples

**Contents** [Overview] | [Getting started] | [Usage]  

This folder contains samples for the most common Vagrant scenarios and the details of the custom YAML-based configuration used in this repository.

## Overview

This repository contains Vagrant environments using custom YAML configurations instead of usual [Vagrantfile]-based approach to provide easier setup for multi-machine environments and to allow simple customizations.

We still use a [Vagrantfile][YAMLVagrantfile] of course, but it simply [loads the configuration][YAMLVagrantRb] from [YAML files][YAMLReference] instead of defining all the options in Ruby. The solution can load multiple YAML files to support e.g. cleaner multi-machine configurations, inheritance or local overrides, and processes them as [ERB templates] to e.g. build dynamic configurations or use secrets from external data sources like environment variables.

[Overview]: #overview

[Vagrantfile]: https://www.vagrantup.com/docs/vagrantfile/
[YAMLVagrantfile]: reference/Vagrantfile
[YAMLVagrantRb]: ../lib/vagrant/local/vagrant.rb
[YAMLReference]: reference/vagrant.yml
[ERB templates]: http://www.stuartellis.name/articles/erb/

## Getting started

The custom YAML configuration provides basically a wrapper around the available Vagrant options, so make sure you are [familiar with the possibilities][VagrantGettingStarted].

Then, copy one of the samples below according to your scenario.

[Getting started]: #getting-started
[VagrantGettingStarted]: https://www.vagrantup.com/docs/getting-started/

## Usage

See below the description of all the available YAML configuration options and the approaches of further customizing a baseline environment.

[Usage]: #usage

### YAML options

#### Empty

This is of less practical relevance, just for your information, an [Empty] configuration also works and sets up the default [Ubuntu] box.

[Empty]: empty
[Ubuntu]: https://atlas.hashicorp.com/ubuntu/boxes/trusty64

#### Single-machine

With the standard [Single-machine] configuration you can define the box you want to use:

```yaml
vms:
  default:
    box: ubuntu/trusty64
```

[Single-machine]: single-machine

#### Multi-machine

For more complex scenarios, the [Multi-machine] configuration allows you to have more than one boxes for an environment:

```yaml
vms:
  default:
    autostart: false
  precise:
    box: ubuntu/precise32
  trusty:
    box: ubuntu/trusty64
```

In configurations like this, `default` serves as an abstract baseline, that is, it does not create a machine named `default`, but the other boxes (in this case `precise` and `trusty`) inherit all its settings. 

[Multi-machine]: multi-machine

#### Providers

You can also configure the basic parameters of the [Providers] being used (currently only VirtualBox is supported):

```yaml
vms:
  default:
    box: ubuntu/trusty64
    providers:
      virtualbox:
        gui: false
        memory: 1024
        cpus: 1
```

[Providers]: providers

#### Network

Vagrant allows the configuration of the various [Network] settings, so do we in YAML:

```yaml
config:
  hostmanager: true

vms:
  default:
    box: ubuntu/trusty64
    network:
      type: private_network
      ip: 172.16.29.156
      ports:
        http:
          host: 8080
          guest: 80
      hostnames:
        - default.network.samples.vagrant.local
```

The global `hostmanager` flag can be used to turn on the [Host Manager plugin]. It requires a static IP address to be defined, and will set up the aliases specificed under `hostnames` on both the host and the guest(s).

[Network]: network
[Host Manager plugin]: https://github.com/devopsgroup-io/vagrant-hostmanager

#### Provisioners

You can define the [File][FileProvisioner], [Chef Solo][ChefSoloProvisioner] and [Reload][ReloadProvisioner] [Provisioners] in YAML:

```yaml
vms:
  default:
    box: ubuntu/trusty64
    provisioners:
      00-file:
        type: file
        source: ~/.gitconfig
        destination: /home/vagrant/.gitconfig
      10-chef-solo:
        type: chef-solo
        recipes:
          - hello_world::default
        attributes:
      20-reload:
        type: reload
```

The provisioners are executed in the alphabetical order of their keys (in this case `00-file` first, then `10-chef-solo` and `20-reload`).

[Provisioners]: provisioners
[FileProvisioner]: https://www.vagrantup.com/docs/provisioning/file.html
[ChefSoloProvisioner]: https://www.vagrantup.com/docs/provisioning/chef_solo.html
[ReloadProvisioner]: https://github.com/aidanns/vagrant-reload

#### Reference

Finally, below is the annotated [Reference] of all the options supproted by the YAML configuration in a single file:

```yaml
# Global configuration.
config:
  hostmanager: false # Use the vagrant-hostmanager plugin. Defaults to false.

# Machine configurations.
vms:
# Default machine configuration.
# Configures the virtual machine for single-machine configurations.
# Used as the baseline that other machines inherit from for multi-machine configurations.
  default:
    autostart: true # Vagrant autostart. Defaults to true.
    box: ubuntu/trusty64 # Vagrant box name. Defaults to ubuntu/trusty64.
# Provider configurations.
    providers:
# VirtualBox configuration.
      virtualbox:
        gui: false
        memory: 1024
        cpus: 1
# Network configuration.
    network:
      type: private_network # Vagrant network type.
      ip: 172.16.10.100 # Static IP address. DHCP if not specified.
      ports: # Forwarded ports from the guest to the host with auto correction.
        http:
          host: 8080
          guest: 80
      hostnames: # Hostname aliases for both the host and the guest. Requires static IP address to be specified.
        - default.reference.samples.vagrant.local
# Provisioner configurations, executed by alphabetical order of keys.
    provisioners:
      00-file: # File provisioner configuration.
        type: file
        source: ~/.gitconfig
        destination: /home/vagrant/.gitconfig
      10-chef-solo: # Chef Solo provisioner configuration. Use Berksfile for cookbook dependencies with the vagrant-berkshelf plugin.
        type: chef-solo
        recipes:
          - hello_world::default
        attributes:
      20-reload: # Reload provisioner configuration using vagrant-reload plugin.
        type: reload
# Additional machine configurations.
# Used for multi-machine configurations.
# Inherits `default` machine's configuration, specify only the differences.
  machine1: # Overrides for machine1.
    providers:
      virtualbox:
        memory: 2048
        cpus: 2
    network:
      ip: 172.16.10.101
      hostnames:
        - machine1.reference.samples.vagrant.local
  machine2: # Overrides for machine2.
    autostart: false
    box: ubuntu/precise32
    network:
      ip: 172.16.10.102
      hostnames:
        - machine2.reference.samples.vagrant.local
```

[Reference]: reference

### Customization

Although the above samples utilize only a single `vagrant.yml` file to define all the options, it is possible to split these configurations for better management via separation or for local customizations.

#### Multi-file configuration basics

We load all the files matching the `vagrant*.yml` pattern from the same folder as the `Vagrantfile` is in, then deep merge them in the alphabetical order of their base names (that is, without the `.yml` extension), so they all get applied, but you can use the first (ones) to provide a baseline configuration the others will inherit from.

For example, this single file configuration:

```yaml
# vagrant.yml
vms:
  default:
    autostart: false
  precise:
    box: ubuntu/precise32
  trusty:
    box: ubuntu/trusty64
```

Is equivalent to the following three files in the same folder:

```yaml
# vagrant.default.yml
vms:
  default:
    autostart: false

# vagrant.precise.yml
vms:
  precise:
    box: ubuntu/precise32

# vagrant.trusty.yml
vms:
  trusty:
    box: ubuntu/trusty64
```

This can also help the readability of complex configurations.

#### Local changes

Files matching the pattern `vagrant*local.yml` are automatically excluded from Git, so you can use them for making temporary local changes.

For example, to give some more resources to the configuration below:

```yaml
# vagrant.yml
vms:
  default:
    box: ubuntu/trusty64
    providers:
      virtualbox:
        gui: false
        memory: 1024
        cpus: 1
```

Create a local file with the overrides:

```yaml
# vagrant.local.yml
vms:
  default:
    providers:
      virtualbox:
        memory: 2048
        cpus: 2
```

This will result in the merged configuration as expected:

```yaml
# vagrant.yml and vagrant.local.yml merged
vms:
  default:
    box: ubuntu/trusty64
    providers:
      virtualbox:
        gui: false
        memory: 2048
        cpus: 2
```

For more complex or permanent changes, [fork this repo][Fork] and simply commit your changes in your own branch like [this one][CustomizationBranch].

[Fork]: https://github.com/gusztavvargadr/vagrant/fork
[CustomizationBranch]: https://github.com/gusztavvargadr/vagrant/compare/master...customization/gusztavvargadr
