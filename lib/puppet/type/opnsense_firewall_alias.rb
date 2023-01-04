# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_firewall_alias',
  docs: <<-EOS,
  @summary
    Manage opnsense firewall aliases.
  @see
    https://wiki.opnsense.org/manual/aliases.html
  @example
    opnsense_firewall_alias { 'hosts_alias':
      device      => 'opnsense-test.device.com',
      type        => 'host',
      content     => ['10.0.0.1', '!10.0.0.5'],
      description => 'Some hosts',
      counters    => true,
      enabled     => true,
      ensure      => 'present',
    }

    opnsense_firewall_alias { 'network_alias':
      device      => 'opnsense-test.device.com',
      type        => 'network',
      content     => ['192.168.1.0/24', '!192.168.1.128/25'],
      description => 'Some networks',
      counters    => true,
      enabled     => true,
      ensure      => 'present',
    }

    opnsense_firewall_alias { 'ports_alias':
      device      => 'opnsense-test.device.com',
      type        => 'port',
      content     => ['80', '443'],
      description => 'Some ports',
      enabled     => true,
      ensure      => 'present',
    }

    opnsense_firewall_alias { 'url_alias':
      device      => 'opnsense-test.device.com',
      type        => 'url',
      content     => ['https://www.spamhaus.org/drop/drop.txt', 'https://www.spamhaus.org/drop/edrop.txt'],
      description => 'spamhaus fetched once.',
      counters    => true,
      enabled     => true,
      ensure      => 'present',
    }

    opnsense_firewall_alias { 'url_table_alias':
      device      => 'opnsense-test.device.com',
      type        => 'urltable',
      content     => ['https://www.spamhaus.org/drop/drop.txt', 'https://www.spamhaus.org/drop/edrop.txt'],
      description => 'Spamhaus block list',
      updatefreq  => 0.5,
      counters    => true,
      enabled     => true,
      ensure      => 'present',
    }

    opnsense_firewall_alias { 'geoip_alias':
      device      => 'opnsense-test.device.com',
      type        => 'geoip',
      content     => ['DE', 'GR'],
      description => 'Only german and greek IPv4 and IPV6 addresses',
      proto       => "IPv4,IPv6",
      counters    => true,
      enabled     => true,
      ensure      => 'present',
    }

    opnsense_firewall_alias { 'networkgroup_alias':
      device      => 'opnsense-test.device.com',
      type        => 'networkgroup',
      content     => ['hosts_alias', 'network_alias'],
      description => 'Combine different network aliases into one',
      counters    => true,
      enabled     => true,
      ensure      => 'present',
    }

    opnsense_firewall_alias { 'mac_alias':
      device      => 'opnsense-test.device.com',
      type        => 'mac',
      content     => ['f4:90:ea', '0c:4d:e9:b1:05:f0'],
      description => 'MAC address or partial mac addresses',
      counters    => true,
      enabled     => true,
      ensure      => 'present',
    }

    opnsense_firewall_alias { 'external_alias':
      device      => 'opnsense-test.device.com',
      type        => 'external',
      description => 'Externally managed alias, this only handles the placeholder.',
      proto       => "IPv4",
      counters    => true,
      enabled     => true,
      ensure      => 'present',
    }

  This type provides Puppet with the capabilities to manage opnsense firewall aliases.

EOS
  features: ['simple_get_filter'],
  title_patterns: [
    {
      pattern: %r{^(?<name>.*[^-])@(?<device>.*)$},
        desc: 'Where the name of the alias and the device are provided with a @',
    },
    {
      pattern: %r{^(?<name>.*)$},
        desc: 'Where only the name is provided',
    },
  ],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the firewall alias you want to manage.',
      behaviour: :namevar,
    },
    device: {
      type: 'String',
      desc: 'The name of the opnsense_device type you want to manage.',
      behaviour: :namevar,
    },
    type: {
      type: 'Enum["host", "network", "port", "url", "urltable", "geoip", "networkgroup", "mac", "external"]',
      desc: 'The type of the firewall alias.',
    },
    description: {
      type: 'String',
      desc: 'The description of the firewall alias.',
    },
    content: {
      type: 'Array[String]',
      desc: 'The content of the firewall alias.',
      default: []
    },
    proto: {
      type: 'Optional[Enum["", "IPv4", "IPv6", "IPv4,IPv6"]]',
      desc: 'The ip protocol which should be used by the firewall alias.',
      default: ''
    },
    updatefreq: {
      type: 'Variant[Enum[""], Numeric]',
      desc: 'How often should the alias be updated in days.',
      default: 0
    },
    counters: {
      type: 'Optional[Variant[Enum[""], Boolean]]',
      desc: 'Enable or disable pfTable statistics for the firewall alias.',
      default: false,
    },
    enabled: {
      type: 'Optional[Variant[Enum[""], Boolean]]',
      desc: 'Enable or disable the firewall alias.',
      default: true,
    },
  },
)
