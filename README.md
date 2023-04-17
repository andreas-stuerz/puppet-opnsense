[![ci](https://github.com/andeman/puppet-opnsense/actions/workflows/ci.yml/badge.svg)](https://github.com/andeman/puppet-opnsense/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/andeman/puppet-opnsense/branch/main/graph/badge.svg?token=0BoY091pEV)](https://codecov.io/gh/andeman/puppet-opnsense)
[![Puppet Forge](https://img.shields.io/puppetforge/v/andeman/opnsense.svg)](https://forge.puppetlabs.com/andeman/opnsense)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/andeman/opnsense.svg)](https://forge.puppetlabs.com/andeman/opnsense)

# opnsense

## Table of Contents

- [opnsense](#opnsense)
  * [Module description](#module-description)
  * [Setup](#setup)
    + [OPNsense firewall](#opnsense-firewall)
      - [Requirements](#requirements)
      - [Install requirements](#install-requirements)
    + [Bastion host](#bastion-host)
      - [Requirements](#requirements-1)
      - [Install requirements](#install-requirements-1)
    + [Access to the OPNsense api](#access-to-the-opnsense-api)
  * [Usage](#usage)
    + [Install and enable opnsense](#install-and-enable-opnsense)
    + [Configure OPNsense firewall(s)](#configure-opnsense-firewall-s-)
    + [Configure a client to export firewall aliases and rules](#configure-a-client-to-export-firewall-aliases-and-rules)
    + [Configure a client to export haproxy server, backends and frontends](#configure-a-client-to-export-haproxy-server--backends-and-frontends)
    + [Dealing with self-signed certificates](#dealing-with-self-signed-certificates)
    + [More examples](#more-examples)
  * [Reference](#reference)
  * [Limitations](#limitations)
  * [CI/CD](#ci-cd)
  * [Development](#development)
    + [Create the local development environment](#create-the-local-development-environment)
    + [Running unit tests](#running-unit-tests)
    + [Running acceptance tests](#running-acceptance-tests)
    + [Teardown](#teardown)
  * [Release module to Puppet Forge](#release-module-to-puppet-forge)
    + [Prepare](#prepare)
    + [Commit and push](#commit-and-push)
    + [configure github actions secrets](#configure-github-actions-secrets)
  * [Contributing](#contributing)
  * [Release Notes](#release-notes)


## Module description

The opnsense module configures OPNsense firewalls.

It allows administrators to manage an OPNsense firewall directly via the [sysutils/puppet-agent](https://github.com/opnsense/plugins/tree/master/sysutils/puppet-agent) opnsense plugin 
and/or manage multiple firewalls from a bastion host running a puppet-agent with [opn-cli](https://pypi.org/project/opn-cli/) installed.

The main target of module is to enable GitOps for your network security policies. Developers could submit
pull request for new firewall rules and loadbalancer configurations and the network or ops team could review it and deploy it to a pre production environment for
testing and verification. If everything passes, you could deploy it to production. 

You can automate the following with the module:

- plugins
- firewall aliases
- firewall rules
- haproxy servers
- haproxy backends
- haproxy frontends
- prometheus nodeexporter
- syslog destinations
- static routes


## Setup

### OPNsense firewall
If you want to manage your firewall directly with a puppet-agent running on the device.
 
#### Requirements
OPNsense plugins:
* [sysutils/puppet-agent](https://github.com/opnsense/plugins/tree/master/sysutils/puppet-agent)
* [os-firewall](https://github.com/opnsense/plugins/tree/master/net/firewall) for managing firewall rules
* [os-haproxy](https://github.com/opnsense/plugins/tree/master/net/haproxy) for managing haproxy rules

#### Install requirements
```
Menu->Firmware->Plugins

Install plugin: sysutils/puppet-agent
```

### Bastion host
If you want a bastion hosts running a puppet-agent which could manage multiple firewalls via https API calls.


#### Requirements
* [opn-cli](https://pypi.org/project/opn-cli/) >= 1.6.0

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

### Access to the OPNsense api
If you want to manage an OPNsense firewall, you need to supply credentials and connection information for the device. 

To create an api_key and api_secret see: https://docs.opnsense.org/development/how-tos/api.html#creating-keys.

**If you want to use ssl verification (recommended):**`

To download the default self-signed cert, open the OPNsense web gui and go to System->Trust->Certificates. Search for the name: "Web GUI SSL certificate" and press the "export user cert" button.

If you use a ca signed certificate, go to System->Trust->Authorities and press the "export CA cert" button to download the ca.

Save the cert or ca and make sure the puppet agent is able to read it.

## Usage

### Install and enable opnsense
```
include opnsense
```

### Configure OPNsense firewall(s)
You can manage multiple opnsense firewalls with this module.

In the following example a single OPNsense firewall running a puppet agent is manged which allows clients to
export configuration via exported resources (manage_resources => true): 
```
# node: opnsense.example.com

class { 'opnsense':
  manage_resources => true,
  devices => {
    'opnsense.example.com' => {
      'url'        => 'https://127.0.0.1/api',
      'api_key'    => 'your_api_key',
      'api_secret' => 'your_api_secret',
      'ssl_verify' => true,
      'timeout'    => 60,
      'ca'         => '~/.opn-cli/ca.pem',
      'plugins'    => {
        'os-helloworld' => {}
      },
      nodeexporter => {
        enabled        => true,
        listen_address => '192.168.1.1',
        listen_port    => '9200',
        cpu            => false,
        exec           => false,
        filesystem     => false,
        loadavg        => false,
        meminfo        => false,
        netdev         => false,
        time           => false,
        devstat        => false,
        interrupts     => true,
        ntp            => true,
        zfs            => true,
      },
      "ensure"      => "present"      
    }
  },
  firewall => {
    aliases => {
      'my_http_ports_local' => {
        'devices'     => ['opnsense.example.com'],
        'type'        => 'port',
        'content'     => ['80', '443'],
        'description' => 'example local http ports',
        'enabled'     => true,
        'ensure'      => present
      },
    },
    rules => {
      'allow all from lan' => {
        'devices'   => ['opnsense.example.com'],
        'sequence'  => '1',
        'action'    => 'pass',
        'interface' => ['lan']
      }
    }
  },
  syslog => {
    destinations => {
      'syslogger 1' => {
        devices     => ['opnsense.example.com'],
        enabled     => true,
        transport   => 'tcp4',
        program     => 'ntp,ntpdate',
        level       => ['crit', 'alert', 'emerg'],
        facility    => ['ntp'],
        hostname    => 'syslog.example.com',
        certificate => '',
        port        => '10514',
        rfc5424     => true,
        ensure      => present,
      },
    },
  },
  route => {
    static => {
      'static route 1' => {
        devices    => ['opnsense.example.com'],
        network    => '10.0.0.98/24',
        gateway    => 'WAN_DHCP',
        disabled   => false,
        ensure     => 'present',
      },
    },
  },
  haproxy => {
    servers => {
      "server1" => {
        "devices"     => ["opnsense.example.com"],
        "description" => "first local server",
        "address"     => "127.0.0.1",
        "port"        => "8091",
      },
      "server2" => {
        "devices"   => ["opnsense.example.com"],
        "description" => "second local server",
        "address"     => "127.0.0.1",
        "port"        => "8092",
      },
    },
    backends => {
      "localhost_backend" => {
        "devices"        => ["opnsense.example.com"],
        "description"    => "local server backend",
        "mode"           => "http",
        "linked_servers" => ["server1", "server2"],
      }
    },
    frontends => {
      "localhost_frontend" => {
        "devices"           => ["opnsense.example.com"],
        "description"       => "local frontend",
        "bind"              => "127.0.0.1:8090",
        "ssl_enabled"       => false,
        "default_backend"   => "localhost_backend",
      }
    },
  },
}
```

### Configure a client to export firewall aliases and rules
This feature use exported resources. You need to enable catalog storage and searching (storeconfigs) on your primary puppet server.

Here the client (client1.example.com) is exporting it´s security configuration to the firewall (opnsense.example.com) defined above:
```
# node: client1.example.com

class { 'opnsense::client::firewall':
  aliases => {
    'client1_example_com' => {
      'devices'     => ['opnsense.example.com'],
      'type'        => 'host',
      'content'     => ['client1.example.com'],
      'description' => 'client.example.com alias',
      'enabled'     => true,
      'ensure'      => present
    },
  },
  rules => {
    'allow https from lan to client1.example.com' => {
      'devices'          => ['opnsense.example.com'],
      'sequence'         => '100',
      'action'           => 'pass',
      'interface'        => ['lan'],
      'protocol'         => 'TCP',
      'destination_net'  => 'client1_example_com',
      'destination_port' => 'https',
      'ensure'           => present
    },
  }
}
```

### Configure a client to export haproxy server, backends and frontends
This feature use exported resources. You need to enable catalog storage and searching (storeconfigs) on your primary puppet server.

Here the client (client1.example.com) is exporting it´s haproxy configuration to the firewall (opnsense.example.com) defined above:
```
# node: client1.example.com

class { 'opnsense::client::haproxy':
  servers  => {
    "client1.example.com" => {
      "devices"     => ["opnsense.example.com"],
      "description" => "client test server",
      "address"     => "client1.example.com",
      "port"        => "443",
      "enabled"     => ture,
    },
  },
  backends => {
    "web_backend" => {
      "devices"        => ["opnsense.example.com"],
      "description"    => "test backend",
      "mode"           => "http",
      "linked_servers" => ["server1", "server2"],
      "enabled"        => false,
    }
  },
  frontends => {
    "web_frontend" => {
      "devices"           => ["opnsense.example.com"],
      "description"       => "test frontend",
      "bind"              => "127.0.0.1:9000",
      "ssl_enabled"       => false,
      "default_backend"   => "localhost_backend",
      "enabled"           => true,
    }
  },
}
```

### Dealing with self-signed certificates
When connecting to the OPNsense API, this module will tell opn-cli to use the system-wide installed CA certificates to verify the SSL connection. However, this will only work when using a valid certificate for the OPNsense WebUI.

If the OPNsense WebUI still uses the pre-installed self-signed certificate, then it is possible to use the OPNsense CA certificate for SSL verification:

```
class { 'opnsense':
  use_system_ca => false,
  ca_file       => '/root/.opn-cli/ca.pem',
  ca_content    => '-----BEGIN CERTIFICATE-----
AAAAAABBBBBBBBBCCCCCCCCCCDDDDDDDDDDDEEEEEEEEEEEFFFFFFFFFGGGGGGGG
-----END CERTIFICATE-----'
}
```

The OPNsense CA certificate can be downloaded from `System: Trust: Authorities` on the OPNsense firewall.

### More examples
You find more examples in the [examples](examples) folder.

## Reference

Types and providers are documented in [REFERENCE.md](REFERENCE.md).

## Limitations

For an extensive list of supported operating systems, see [metadata.json](metadata.json)

## CI/CD
CI/CD is done via [Github Actions](https://github.com/andeman/puppet-opnsense/actions). 

## Development

You need to install the following requirements to setup the local development environment:

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
## Release module to Puppet Forge

### Prepare
First prepare the release with:

```
./scripts/release_prep
```

This will set the version in `metadata.json`, create `REFERENCE.md` and  `CHANGELOG.md`.

### Commit and push
Then commit the changes and push them to the repository.

### configure github actions secrets
https://github.com/andeman/puppet-opnsense/settings/secrets/actions

Ensure that the following secrets are set in the github repository:
- FORGE_API_KEY (your puppet forge api key)


## Contributing

Please use the GitHub issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.

All contributions must pass all existing tests, new features should provide additional unit/acceptance tests.

## Release Notes
See [Changelog](CHANGELOG.md).
