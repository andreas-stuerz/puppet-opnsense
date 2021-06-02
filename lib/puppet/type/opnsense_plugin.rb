# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_plugin',
  docs: <<-EOS,
  @summary 
    Manage installed opnsense plugins 
  @see
    https://docs.opnsense.org/plugins.html
  @example
  opnsense_plugin { 'os-acme-client':
    device => 'opnsense.example.com'
    ensure => 'present',
  }

  This type provides Puppet with the capabilities to manage opnsense plugins.

  **Autorequires**:
  * `opnsense_device[foo.example.com]`
EOS
  features: [],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this plugin should be present or absent on the opnsense device.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the plugin you want to manage.',
      behaviour: :namevar,
    },
    device: {
        type: 'String',
        desc: 'The name of the opnsense_device type you want to manage.',
    },
  },
  autorequire: {
      opnsense_device: '$device', # evaluates to the value of the `device` attribute
  },
)
