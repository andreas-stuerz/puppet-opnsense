# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_route_static',
  docs: <<-EOS,
  @summary
    Manage opnsense static routes

  @example
    opnsense_route_static { 'example route static':
      device      => 'opnsense-test.device.com',
      network     => '10.0.0.98/24',
      gateway     => 'WAN_DHCP',
      disabled    => false,
      ensure      => 'present',
    }

  This type provides Puppet with the capabilities to manage opnsense static routes.

EOS
  features: ['simple_get_filter'],
    title_patterns: [
      {
        pattern: %r{^(?<descr>.*)@(?<device>.*)$},
        desc: 'Where the descr and the device are provided with a @',
      },
      {
        pattern: %r{^(?<descr>.*)$},
        desc: 'Where only the descr is provided',
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
    uuid: {
      type: 'Optional[String]',
      desc: 'The uuid of the rule.',
      behaviour: :init_only,
    },
    network: {
      type: 'String',
      desc: 'Destination network for this static route',
    },
    gateway: {
      type: 'String',
      desc: 'Choose which gateway this route applies to eg. Null4 for 127.0.01, Null6 for ::1 or see opn-cli route gateway status.',
    },
    descr: {
      type: 'String',
      desc: 'You may enter a description here for your reference (not parsed).',
      behaviour: :namevar,
    },
    disabled: {
      type: 'Boolean',
      desc: 'Set this option to disable this static route without removing it from the list.',
    },

  },
)
