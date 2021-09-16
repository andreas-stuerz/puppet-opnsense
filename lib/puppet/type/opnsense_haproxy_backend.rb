# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_haproxy_backend',
  docs: <<-EOS,
    @summary
        Manage opnsense haproxy backends
    @example
    opnsense_haproxy_backend { 'webserver_pool':
      device                           => 'opnsense-test.device.com',
      enabled                          => true,
      description                      => 'backend for webserver',
      mode                             => 'http',
      algorithm                        => 'source',
      random_draws                     => '2',
      proxy_protocol                   => '',
      linked_servers                   => [],
      linked_resolver                  => '',
      resolver_opts                    => [],
      resolve_prefer                   => '',
      source                           => '',
      health_check_enabled             => true,
      health_check                     => '',
      health_check_log_status          => true,
      check_interval                   => '',
      check_down_interval              => '',
      health_check_fall                => '',
      health_check_rise                => '',
      linked_mailer                    => '',
      http2_enabled                    => true,
      http2_enabled_nontls             => true,
      ba_advertised_protocols          => ['h2', 'http11'],
      persistence                      => 'sticktable',
      persistence_cookiemode           => 'piggyback',
      persistence_cookiename           => 'SRVCOOKIE',
      persistence_stripquotes          => true,
      stickiness_pattern               => 'sourceipv4',
      stickiness_data_types            => '',
      stickiness_expire                => '30m',
      stickiness_size                  => '50k',
      stickiness_cookiename            => '',
      stickiness_cookielength          => '',
      stickiness_conn_rate_period      => '10s',
      stickiness_sess_rate_period      => '10s',
      stickiness_http_req_rate_period  => '10s',
      stickiness_http_err_rate_period  => '10s',
      stickiness_bytes_in_rate_period  => '1m',
      stickiness_bytes_out_rate_period => '1m',
      basic_auth_enabled               => true,
      basic_auth_users                 => [],
      basic_auth_groups                => [],
      tuning_timeout_connect           => '',
      tuning_timeout_check             => '',
      tuning_timeout_server            => '',
      tuning_retries                   => '',
      custom_options                   => '',
      tuning_defaultserver             => '',
      tuning_noport                    => true,
      tuning_httpreuse                 => safe,
      tuning_caching                   => true,
      linked_actions                   => [],
      linked_errorfiles                => [],
      ensure                           => 'present',
    }

    This type provides Puppet with the capabilities to manage haproxy backends

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
        desc: 'The uuid of the backend.',
        behaviour: :init_only,
    },
    enabled: {
      type: 'Boolean',
        desc: 'Enable or disable this backend.',
        default: true
    },
    description: {
      type: 'String',
        desc: 'The backend description.',
    },
    mode: {
      type: "Enum['http', 'tcp']",
        desc: 'Set the running mode or protocol of the backend pool.',
        default: 'http',
    },
    algorithm: {
      type: "Enum['source', 'roundrobin', 'static-rr', 'leastconn', 'uri', 'random']",
        desc: 'Define the load balancing algorithm to be used in a backend pool.',
        default: 'source',
    },
    random_draws: {
      type: 'String',
        desc: 'When using the Random Balancing Algorithm, this value indicates the number of draws.',
        default: '2'
    },
    proxy_protocol: {
      type: "Enum['', 'v1', 'v2']",
        desc: 'Enforces use of the PROXY protocol over any connection established to the configured servers.',
        default: '',
    },
    linked_servers: {
      type: 'Array[String]',
        desc: 'Specify the uuids of the servers linked to this backend.',
        default: [],
    },
    linked_resolver: {
      type: 'Optional[String]',
      desc: 'Specify the uuid of the custom resolver configuration that should be used for all servers in this backend.',
    },
    resolver_opts: {
      type: 'Array[String]',
        desc: 'Add resolver options.',
        default: [],
    },
    resolve_prefer: {
      type: "Enum['', 'ipv4', 'ipv6']",
        desc: 'When DNS resolution is enabled and multiple IP addresses from different families are returned use this.',
        default: '',
    },
    source: {
      type: 'Optional[String]',
      desc: 'Sets the source address which will be used when connecting to the server(s).',
    },
    health_check_enabled: {
      type: 'Boolean',
        desc: 'Enable or disable health checking.',
        default: true
    },
    health_check: {
      type: 'Optional[String]',
        desc: 'Specify the uuid of the health check for servers in this backend.',
    },
    health_check_log_status: {
      type: 'Boolean',
        desc: 'Enable to log health check status updates.',
        default: true
    },
    check_interval: {
      type: 'Optional[String]',
      desc: 'Sets the interval (in ms) for running health checks on all configured servers.',
    },
    check_down_interval: {
      type: 'Optional[String]',
      desc: 'Sets the interval (in ms) for running health checks on a configured server when the server state is DOWN',
    },
    health_check_fall: {
      type: 'Optional[String]',
      desc: 'The number of consecutive unsuccessful health checks before a server is considered as unavailable.',
    },
    health_check_rise: {
      type: 'Optional[String]',
      desc: 'The number of consecutive successful health checks before a server is considered as available.',
    },
    linked_mailer: {
      type: 'Optional[String]',
        desc: 'Specify the uuid of the e-mail alert configuration linked to this backend.',
    },
    http2_enabled: {
      type: 'Boolean',
        desc: 'Enable support for end-to-end HTTP/2 communication.',
        default: true
    },
    http2_enabled_nontls: {
      type: 'Boolean',
        desc: 'Enable support for HTTP/2 even if TLS is not enabled.',
        default: true
    },
    ba_advertised_protocols: {
      type: 'Array[String]',
        desc: 'Enable support for HTTP/2 even if TLS is not enabled.',
      default: ['h2', 'http11']
    },
    persistence: {
      type: "Enum['', 'sticktable', 'cookie']",
        desc: 'Choose how HAProxy should track user-to-server mappings.',
        default: 'sticktable',
    },
    persistence_cookiemode: {
      type: "Enum['piggyback', 'new']",
        desc: 'Cookie mode to use for persistence.',
        default: 'piggyback',
    },
    persistence_cookiename: {
      type: 'String',
        desc: 'Cookie name to use for persistence.',
        default: 'SRVCOOKIE',
    },
    persistence_stripquotes: {
      type: 'Boolean',
        desc: 'Enable to automatically strip quotes from the cookie value.',
        default: true
    },
    stickiness_pattern: {
      type: "Enum['', 'sourceipv4', 'sourceipv6', 'cookievalue', 'rdpcookie']",
        desc: 'Choose a request pattern to associate a user to a server.',
        default: 'sourceipv4',
    },
    stickiness_data_types: {
      type: "Array[Enum[
            '', 'conn_cnt', 'conn_cur', 'conn_rate', 'sess_cnt', 'sess_rate', 'http_req_cnt', 'http_req_rate',
            'http_err_cnt', 'http_err_rate', 'bytes_in_cnt', 'bytes_in_rate', 'bytes_out_cnt', 'bytes_out_rate'
            ]]",
       desc: 'This is used to store additional information in the stick-table.',
       default: [],
    },
    stickiness_expire: {
      type: 'String',
        desc: 'The maximum duration of an entry in the stick table. Valid suffixes d, h, m, s, ms.',
        default: '30m',
    },
    stickiness_size: {
      type: 'String',
        desc: 'The maximum number of entries that can fit in the stick table. Valid suffixes k, m, g.',
        default: '50k',
    },
    stickiness_cookiename: {
      type: 'Optional[String]',
        desc: 'Cookie name to use for stick table.',
    },
    stickiness_cookielength: {
      type: 'Optional[String]',
        desc: 'The maximum number of characters that will be stored in the stick table.',
    },
    stickiness_conn_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '10s',
    },
    stickiness_sess_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '10s',
    },
    stickiness_http_req_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '10s',
    },
    stickiness_http_err_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '10s',
    },
    stickiness_bytes_in_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '1m',
    },
    stickiness_bytes_out_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '1m',
    },
    basic_auth_enabled: {
      type: 'Boolean',
        desc: 'Enable HTTP basic authentication.',
        default: true
    },
    basic_auth_users: {
      type: 'Array[String]',
        desc: 'Specify the uuids of the basic auth users for this backend.',
        default: [],
    },
    basic_auth_groups: {
      type: 'Array[String]',
        desc: 'Specify the uuids of the basic auth groups for this backend.',
        default: []
    },
    tuning_timeout_connect: {
      type: 'Optional[String]',
        desc: 'Set the maximum time to wait for a connection attempt to a server to succeed. Valid suffixes d, h, m, s, ms, us',
    },
    tuning_timeout_check: {
      type: 'Optional[String]',
        desc: 'Sets an additional read timeout for running health checks on a server. Valid suffixes d, h, m, s, ms, us',
    },
    tuning_timeout_server: {
      type: 'Optional[String]',
        desc: 'Set the maximum inactivity time on the server side. Valid suffixes d, h, m, s, ms, us',
    },
    tuning_retries: {
      type: 'Optional[String]',
        desc: 'Set the number of retries to perform on a server after a connection failure.',
    },
    custom_options: {
      type: 'Optional[String]',
        desc: 'These lines will be added to the HAProxy backend configuration.',
    },
    tuning_defaultserver: {
      type: 'Optional[String]',
        desc: 'Default option for all server entries.',
    },
    tuning_noport: {
      type: 'Boolean',
        desc: "Don't use port on server, use the same port as frontend receive.",
        default: true
    },
    tuning_httpreuse: {
      type: "Enum['', 'never', 'safe', 'aggressive', 'always']",
        desc: 'Choose a request pattern to associate a user to a server.',
        default: 'safe',
    },
    tuning_caching: {
      type: 'Boolean',
        desc: 'Enable caching of responses from this backend.',
        default: true
    },
    linked_actions: {
      type: 'Array[String]',
        desc: 'Specify the uuids of the rules to be included in this backend.',
        default: []
    },
    linked_errorfiles: {
      type: 'Array[String]',
        desc: 'Specify the uuids of the error messages to be included in this backend.',
        default: []
    },
  },
)
