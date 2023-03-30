# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_syslog_destination',
  docs: <<-EOS,
  @summary
    Manage opnsense syslog destination

  @example
    opnsense_syslog_destination { 'example syslog destination':
      device      => 'opnsense-test.device.com',
      enabled     => true,
      transport   => 'tls4',
      program     => 'ntp,ntpdate,ntpd',
      level       => ['info', 'notice', 'warn', 'err', 'crit', 'alert', 'emerg'],
      facility    => ['ntp', 'security', 'console'],
      hostname    => '10.0.0.2',
      certificate => '60cc4641eb577',
      port        => '514',
      rfc5424     => true,
      ensure      => 'present',
    }

  This type provides Puppet with the capabilities to manage opnsense syslog destination.

EOS
  features: ['simple_get_filter'],
    title_patterns: [
      {
        pattern: %r{^(?<description>.*)@(?<device>.*)$},
        desc: 'Where the description and the device are provided with a @',
      },
      {
        pattern: %r{^(?<description>.*)$},
        desc: 'Where only the description is provided',
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
    enabled: {
      type: 'Boolean',
      desc: 'Set this option to enable this destination.',
    },
    transport: {
      type: "Enum['udp4', 'tcp4', 'udp6', 'tcp6', 'tls4', 'tls6']",
      desc: 'Transport protocol',
    },
    program: {
      type: 'String',
      desc: 'Choose which applications should be forwarded to the specified target, omit to select all.',
    },
    level: {
      type: "Array[
        Enum['', 'debug', 'info', 'notice', 'warn', 'err', 'crit', 'alert', 'emerg']
      ]",
      desc: 'Choose which levels to include, omit to select all.',
    },
    facility: {
      type: "Array[
        Enum[
            '', 'kern', 'user', 'mail', 'daemon', 'auth', 'syslog', 'lpr', 'news',
            'uucp', 'cron', 'authpriv', 'ftp', 'ntp', 'security', 'console',
            'local0', 'local1', 'local2', 'local3', 'local4', 'local5', 'local6', 'local7'
        ]
      ]",
      desc: 'Choose which facilities to include, omit to select all.',
    },
    hostname: {
      type: 'String',
      desc: 'The hostname or ip address of the syslog destination.',
    },
    certificate: {
      type: 'String',
      desc: 'Transport certificate to use, please make sure to check the general system log when experiencing issues.
Error messages can be a bit cryptic from time to time, in which case
"https://support.oneidentity.com/kb/263658/common-issues-of-tls-encrypted-message-transfer this is a good
resource for tracking common issues.',
    },
    port: {
      type: 'String',
      desc: 'The port of the syslog destination.',
    },
    rfc5424: {
      type: 'Boolean',
      desc: 'Use rfc5424 formated messages for this destination.',
    },
    description: {
      type: 'String',
      desc: 'You may enter a description here for your reference.',
      behaviour: :namevar,
    },

  },
)
