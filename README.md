[![Unit Tests](https://github.com/andeman/puppet-opnsense/actions/workflows/unit_tests.yml/badge.svg)](https://github.com/andeman/puppet-opnsense/actions/workflows/unit_tests.yml)
[![Acceptance Tests](https://github.com/andeman/puppet-opnsense/actions/workflows/acceptance_tests.yml/badge.svg)](https://github.com/andeman/puppet-opnsense/actions/workflows/acceptance_tests.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/andeman/opnsense.svg)](https://forge.puppetlabs.com/andeman/opnsense)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/andeman/opnsense.svg)](https://forge.puppetlabs.com/andeman/opnsense)

# opnsense

## Table of Contents

- [Description](#description)
- [Setup](#setup)
  * [OPNsense firewall](#opnsense-firewall)
    + [Requirements](#requirements)
    + [Install requirements](#install-requirements)
  * [Bastion host](#bastion-host)
    + [Requirements](#requirements-1)
    + [Install requirements](#install-requirements-1)
- [Usage](#usage)
  * [Creating the device](#creating-the-device)
  * [Configure your OPNsense Firewall](#configure-your-opnsense-firewall)
- [Reference](#reference)
- [Limitations](#limitations)
- [CI/CD](#ci-cd)
- [Development](#development)
  * [Create the local development environment](#create-the-local-development-environment)
  * [Running unit tests](#running-unit-tests)
  * [Running acceptance tests](#running-acceptance-tests)
  * [Teardown](#teardown)
- [Contributing](#contributing)


## Description

The opnsense module configures OPNsense firewalls with custom types and providers.

It allows administrators to manage an OPNsense firewall directly via the [sysutils/puppet-agent](https://github.com/opnsense/plugins/tree/master/sysutils/puppet-agent) opnsense plugin 
and/or manage multiple firewalls from a bastion host running a puppet-agent with [opn-cli](https://pypi.org/project/opn-cli/) installed.

## Setup

### OPNsense firewall
If you want to manage your firewall directly with a puppet-agent running on the device.
 
#### Requirements
* OPNsense plugin: [sysutils/puppet-agent](https://github.com/opnsense/plugins/tree/master/sysutils/puppet-agent)

#### Install requirements
```
Menu->Firmware->Plugins

Install Plugin: sysutils/puppet-agent
```

### Bastion host
If you want a bastion hosts running a puppet-agent which could manage multiple firewalls via https API calls.


#### Requirements
* [opn-cli](https://pypi.org/project/opn-cli/)
* puppetlabs/resource_api (puppet < 6.0)

#### Install requirements
```
$packages = [
    'python3',
    'python3-pip',
]
$pip_packages = [
    'opn-cli',
]
package { $packages:
    ensure => present,
}
-> package { $pip_packages:
    ensure   => latest,
    provider => 'pip3',
}
```

## Usage

### Creating the device

If you want to manage an OPNsense Firewall, you need to supply credentials and connection information for the device. 

For each device you want to mange create an [opnsense_device](REFERENCE.md#opnsense_device) type:
```
opnsense_device { 'opnsense.example.com':
  url        => 'https://opnsense.example.com/api',
  api_key    => 'your_api_key',
  api_secret => Sensitive('your_api_secret'),
  timeout    => 60,
  ssl_verify => true,
  ca         => '/path/to/ca.pem',
  ensure     => 'present',
}
```

To create an api_key and api_secret see: https://docs.opnsense.org/development/how-tos/api.html#creating-keys.

**If you want to use ssl verification (recommended):**

To download the default self-signed cert, open the OPNsense web gui and go to System->Trust->Certificates. Search for the name: "Web GUI SSL certificate" and press the "export user cert" button.

If you use a ca signed certificate, go to System->Trust->Authorities and press the "export CA cert" button to download the ca.

Save the cert or ca and make sure the puppet agent is able to read it.

### Configure your OPNsense Firewall

If you have at least one configured opnsense_device, you could start to use other puppet types to manage the device.

In the following example we use the [opnsense_plugin](REFERENCE.md#opnsense_plugin) type to manage the installed plugins 
on the opnsense device "opnsense.example.com":

```
opnsense_plugin { 'os-helloworld':
  device => 'opnsense.example.com',
  ensure => 'present',
}
```

See [Reference.md](#Reference) for all available puppet types to manage your OPNsense firewall.


## Reference

Types and providers are documented in [REFERENCE.md](REFERENCE.md).

## Limitations

For an extensive list of supported operating systems, see [metadata.json](metadata.json)

## CI/CD
CI/CD is done via [Github Actions](https://github.com/andeman/puppet-opnsense/actions). 

## Development

Install the you following requirements if you need alocal development environment:

* [vagrant](vagrantup.com/docs/installation)
* [docker](https://runnable.com/docker/getting-started/)
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Puppet Development Kit (PDK)](https://puppet.com/docs/pdk/latest/pdk_install.html)

### Create the local development environment
```
scripts/create_test_env 
```

### Running unit tests
Unit testing uses [pdk](https://puppet.com/docs/pdk/latest/pdk_testing.html)
```
scripts/unit_tests
```

### Running acceptance tests
Acceptance testing uses [puppet litmus](https://puppetlabs.github.io/litmus/).

```
scripts/acceptance_tests
```
### Teardown
```
scripts/remove_test_env
```

## Contributing

Please use the GitHub issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.

All contributions must pass all existing tests, new features should provide additional unit/acceptance tests.

