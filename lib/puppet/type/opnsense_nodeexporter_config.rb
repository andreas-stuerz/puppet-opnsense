# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_nodeexporter_config',
  docs: <<-EOS,
    @summary
      Manage opnsense prometheus nodeexporter config
    @example
      opnsense_nodeexporter_config { 'opnsense.example.com':
        device         => 'opnsense.example.com',
        enabled        => false,
        listen_address => '0.0.0.0',
        listen_port    => '9100',
        cpu            => true,
        exec           => true,
        filesystem     => true,
        loadavg        => true,
        meminfo        => true,
        netdev         => true,
        time           => true,
        devstat        => true,
        interrupts     => false,
        ntp            => false,
        zfs            => false,
        ensure         => 'present',
      }

    This type provides Puppet with the capabilities to manage opnsense nodeexporter config.

EOS
  features: ['simple_get_filter'],
  title_patterns: [
    {
      pattern: %r{^(?<device>.*)$},
      desc: 'Where only the device is provided',
    },
  ],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    device: {
      type: 'String',
      desc: 'The name of the opnsense_device type you want to manage.',
      behaviour: :namevar,
    },
    enabled: {
      type: 'Boolean',
      desc: 'Enable or disable the node_exporter plugin.',
    },
    listen_address: {
      type: 'String',
      desc: 'Set node_exporter\'s listen address. By default, node_exporter will listen on 0.0.0.0 (all interfaces).',
    },
    listen_port: {
      type: 'String',
      desc: 'Set node_exporter\'s listen port. By default, node_exporter will listen on port 9100.',
    },
    cpu: {
      type: 'Boolean',
      desc: 'Enable or disable the cpu collector.',
    },
    exec: {
      type: 'Boolean',
      desc: 'Enable or disable the exec collector.',
    },
    filesystem: {
      type: 'Boolean',
      desc: 'Enable or disable the filesystem collector.',
    },
    loadavg: {
      type: 'Boolean',
      desc: 'Enable or disable the loadavg collector.',
    },
    meminfo: {
      type: 'Boolean',
      desc: 'Enable or disable the meminfo collector.',
    },
    netdev: {
      type: 'Boolean',
      desc: 'Enable or disable the netdev collector.',
    },
    time: {
      type: 'Boolean',
      desc: 'Enable or disable the time collector.',
    },
    devstat: {
      type: 'Boolean',
      desc: 'Enable or disable the devstat collector.',
    },
    interrupts: {
      type: 'Boolean',
      desc: 'Enable or disable the interrupts collector.',
    },
    ntp: {
      type: 'Boolean',
      desc: 'Enable or disable the ntp collector.',
    },
    zfs: {
      type: 'Boolean',
      desc: 'Enable or disable the zfs collector.',
    },
  },
)
