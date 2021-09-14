# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_haproxy_server',
  docs: <<-EOS,
  @summary
    Manage opnsense haproxy servers
  @example
    opnsense_haproxy_server { 'webserver1':
      device                 => 'opnsense-test.device.com',
      enabled                => true,
      description            => 'primary webserver',
      address                => 'webserver1.example.com',
      port                   => '443',
      checkport              => '80',
      mode                   => 'active',
      type                   => 'static',
      service_name           => '',
      linked_resolver        => '',
      resolver_opts          => ['allow-dup-ip','ignore-weight','prevent-dup-ip'],
      resolve_prefer         => 'ipv4',
      ssl                    => true,
      ssl_verify             => true,
      ssl_ca                 => [],
      ssl_crl                => [],
      ssl_client_certificate => '5eba6f0f352e3',
      weight                 => '10',
      check_interval         => '100',
      check_down_interval    => '200',
      source                 => '10.0.0.1',
      advanced               => 'send-proxy',
      ensure                 => 'present',
    }

  This type provides Puppet with the capabilities to manage opnsense haproxy server

EOS
  features: ['simple_get_filter'],
  title_patterns: [
    {
      pattern: %r{^(?<name>.*[^-])@(?<device>.*)$},
        desc: 'Where the name of the server and the device are provided with a @',
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
      desc: 'The name of the resource you want to manage.',
      behaviour: :namevar,
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
        desc: 'Enable or disable this rule.',
        default: true
    },
    description: {
      type: 'String',
        desc: 'The server description.',
    },
    address: {
      type: 'String',
        desc: 'The FQDN or the IP address of this server.',
    },
    port: {
      type: 'String',
        desc: 'Provide the TCP or UDP communication port for this server.',
    },
    checkport: {
      type: 'Optional[String]',
        desc: 'Provide the TCP communication port to use during check.',
    },
    mode: {
      type: "Enum['', 'active', 'backup', 'disabled']",
        desc: 'Sets the operation mode to use for this server.',
        default: 'active',
    },
    type: {
      type: "Enum['static', 'template']",
        desc: 'Sets the operation mode to use for this server.',
        default: 'static',
    },
    service_name: {
      type: 'Optional[String]',
        desc: 'FQDN for all the servers this template initializes or a service name to discover via DNS SRV records.',
    },
    number: {
      type: 'Optional[String]',
        desc: 'The number of servers this template initializes, i.e. 5 or 1-5.',
    },
    linked_resolver: {
      type: 'Optional[String]',
        desc: 'Specify the uuid of the resolver to discover available services via DNS.',
    },
    resolver_opts: {
      type: 'Optional[Array[String]]',
        desc: 'Add resolver options.',
    },
    resolve_prefer: {
      type: "Enum['', 'ipv4', 'ipv6']",
        desc: 'When DNS resolution is enabled and multiple IP addresses from different families are returned use this.',
        default: '',
    },
    ssl: {
      type: 'Boolean',
        desc: 'Enable or disable SSL communication with this server.',
        default: true
    },
    ssl_verify: {
      type: 'Boolean',
        desc: 'Enable or disable server ssl certificate verification.',
        default: true
    },
    ssl_ca: {
      type: 'Optional[Array[String]]',
        desc: "These CA Ids will be used to verify server's certificate.",
    },
    ssl_crl: {
      type: 'Optional[Array[String]]',
        desc: "This certificate revocation list Ids will be used to verify server's certificate.",
    },
    ssl_client_certificate: {
      type: 'Optional[String]',
        desc: 'This certificate will be sent if the server send a client certificate request.',
    },
    weight: {
      type: 'Optional[String]',
        desc: "Adjust the server's weight relative to other servers.",
    },
    check_interval: {
      type: 'Optional[String]',
        desc: 'Sets the interval (in milliseconds) for running health checks on this server.',
    },
    check_down_interval: {
      type: 'Optional[String]',
        desc: (
          'Sets the interval (in milliseconds) for running health checks on the server when the server state is DOWN.'
        ),
    },
    source: {
      type: 'Optional[String]',
        desc: 'Sets the source address which will be used when connecting to the server.',
    },
    advanced: {
      type: 'Optional[String]',
        desc: (
          'list of parameters that will be appended to the server line in every backend where this server will be used.'
        ),
    },
  },
)
