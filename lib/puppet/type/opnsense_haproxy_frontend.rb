# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_haproxy_frontend',
  docs: <<-EOS,
  @summary
    Manage opnsense haproxy frontends
  @example
    opnsense_haproxy_frontend { 'webserver_frontend':
      device                           => 'opnsense-test.device.com',
      enabled                          => true,
      description                      => 'frontend for webserver',
      bind                             => '127.0.0.1:8080',
      bind_options                     => '',
      mode                             => 'http',
      default_backend                  => '',
      ssl_enabled                      => true,
      ssl_certificates                 => ['60cc4641eb577', '5eba6f0f352e3'],
      ssl_default_certificate          => '60cc4641eb577',
      ssl_custom_options               => '',
      ssl_advanced_enabled             => true,
      ssl_bind_options                 => ['prefer-client-ciphers'],
      ssl_min_version                  => 'TLSv1.2',
      ssl_max_version                  => '',
      ssl_cipher_list                  => 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256',
      ssl_cipher_suites                => 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
      ssl_hsts_enabled                 => true,
      ssl_hsts_include_sub_domains     => true,
      ssl_hsts_preload                 => true,
      ssl_hsts_max_age                 => '15768000',
      ssl_client_auth_enabled          => true,
      ssl_client_auth_verify           => 'required',
      ssl_client_auth_cas              => [],
      ssl_client_auth_crls             => [],
      basic_auth_enabled               => true,
      basic_auth_users                 => [],
      basic_auth_groups                => [],
      tuning_max_connections           => '',
      tuning_timeout_client            => '',
      tuning_timeout_http_req          => '',
      tuning_timeout_http_keep_alive   => '',
      linked_cpu_affinity_rules        => [],
      logging_dont_log_null            => true,
      logging_dont_log_normal          => true,
      logging_log_separate_errors      => true,
      logging_detailed_log             => true,
      logging_socket_stats             => true,
      stickiness_pattern               => '',
      stickiness_data_types            => [''],
      stickiness_expire                => '30m',
      stickiness_size                  => '50k',
      stickiness_counter               => true,
      stickiness_counter_key           => 'src',
      stickiness_length                => '',
      stickiness_conn_rate_period      => '10s',
      stickiness_sess_rate_period      => '10s',
      stickiness_http_req_rate_period  => '10s',
      stickiness_http_err_rate_period  => '10s',
      stickiness_bytes_in_rate_period  => '1m',
      stickiness_bytes_out_rate_period => '1m',
      http2_enabled                    => true,
      http2_enabled_nontls             => true,
      advertised_protocols             => ['h2', 'http11'],
      forward_for                      => true,
      connection_behaviour             => 'http-keep-alive',
      custom_options                   => '',
      linked_actions                   => [],
      linked_errorfiles                => [],
      ensure                           => 'present',
    }

  This type provides Puppet with the capabilities to manage opnsense haproxy frontends.

EOS
  features: ['simple_get_filter'],
  title_patterns: [
    {
      pattern: %r{^(?<name>.*[^-])@(?<device>.*)$},
        desc: 'Where the name of the frontend and the device are provided with a @',
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
        desc: 'The uuid of the frontend.',
        behaviour: :init_only,
    },
    enabled: {
      type: 'Boolean',
        desc: 'Enable or disable this frontend.',
        default: true
    },
    description: {
      type: 'String',
        desc: 'The backend description.',
    },
    bind: {
      type: 'String',
        desc: 'Configure listen addresses for this public service, i.e. 127.0.0.1:8080.',
    },
    bind_options: {
      type: 'Optional[String]',
        desc: 'A list of parameters that will be appended to every Listen Address line e.g. accept-proxy npn http/1.1.',
    },
    mode: {
      type: "Enum['http', 'ssl', 'tcp']",
        desc: 'Set the running mode or protocol for this public service.',
        default: 'http',
    },
    default_backend: {
      type: 'String',
        desc: 'Set the default backend pool to use for this public service.',
        default: '',
    },
    ssl_enabled: {
      type: 'Boolean',
        desc: 'Enable SSL offloading.',
        default: true
    },
    ssl_certificates: {
      type: 'Array[String]',
        desc: 'Select certificates to use for SSL offloading.',
        default: [],
    },
    ssl_default_certificate: {
      type: 'String',
        desc: 'This certificate will be presented if no SNI is provided by the client if the client provides an SNI hostname which does not match any certificate.',
        default: ''
    },
    ssl_custom_options: {
      type: 'String',
        desc: 'Pass additional SSL parameters to the HAProxy configuration.',
        default: ''
    },
    ssl_advanced_enabled: {
      type: 'Boolean',
        desc: 'Enable or disable advanced SSL settings.',
        default: true
    },
    ssl_bind_options: {
      type: "Array[Enum[
            '', 'no-sslv3', 'no-tlsv10', 'no-tlsv11', 'no-tlsv12', 'no-tlsv13', 'no-tls-tickets', 'force-sslv3',
            'force-tlsv10', 'force-tlsv11', 'force-tlsv12', 'force-tlsv13', 'prefer-client-ciphers', 'strict-sni'
            ]]",
        desc: 'Used to enforce or disable certain SSL options.',
        default: ['prefer-client-ciphers'],
    },
    ssl_min_version: {
      type: "Enum['', 'SSLv3', 'TLSv1.0', 'TLSv1.1', 'TLSv1.2', 'TLSv1.3']",
        desc: 'Used to enforce or disable certain SSL options.',
        default: 'TLSv1.2',
    },
    ssl_max_version: {
      type: "Enum['', 'SSLv3', 'TLSv1.0', 'TLSv1.1', 'TLSv1.2', 'TLSv1.3']",
        desc: 'Used to enforce or disable certain SSL options.',
        default: '',
    },
    ssl_cipher_list: {
      type: 'String',
        desc: 'The default string describing the list of cipher algorithms ("cipher suite") that are negotiated during the SSL/TLS handshake up to TLSv1.2.',
        default: 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:
ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256',
    },
    ssl_cipher_suites: {
      type: 'String',
        desc: 'The default string describing the list of cipher algorithms ("cipher suite") that are negotiated during the SSL/TLS handshake for TLSv1.3.',
        default: 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
    },
    ssl_hsts_enabled: {
      type: 'Boolean',
        desc: 'Enable HTTP Strict Transport Security.',
        default: true
    },
    ssl_hsts_include_sub_domains: {
      type: 'Boolean',
        desc: 'Enable or disable if all present and future subdomains will be HTTPS.',
        default: true
    },
    ssl_hsts_preload: {
      type: 'Boolean',
        desc: 'Enable if you like this domain to be included in the HSTS preload list.',
        default: true
    },
    ssl_hsts_max_age: {
      type: 'String',
        desc: 'Future requests to the domain should use only HTTPS for the specified time (in seconds).',
        default: '15768000'
    },
    ssl_client_auth_enabled: {
      type: 'Boolean',
        desc: 'Enable client certificate authentication.',
        default: true
    },
    ssl_client_auth_verify: {
      type: "Enum['', 'none', 'optional', 'required']",
        desc: "If set to 'optional' or 'required', client certificate is requested.",
        default: 'required',
    },
    ssl_client_auth_cas: {
      type: 'Array[String]',
        desc: 'Select CA certificates to use for client certificate authentication.',
        default: [],
    },
    ssl_client_auth_crls: {
      type: 'Array[String]',
        desc: 'Select CRLs to use for client certificate authentication.',
        default: [],
    },
    basic_auth_enabled: {
      type: 'Boolean',
        desc: 'Enable HTTP Basic Authentication.',
        default: true
    },
    basic_auth_users: {
      type: 'Array[String]',
        desc: 'Specify the uuids of the basic auth users for this frontend.',
        default: [],
    },
    basic_auth_groups: {
      type: 'Array[String]',
        desc: 'Specify the uuids of the basic auth groups for this frontend.',
        default: []
    },
    tuning_max_connections: {
      type: 'String',
        desc: 'Set the maximum number of concurrent connections for this public service.',
        default: '',
    },
    tuning_timeout_client: {
      type: 'String',
        desc: 'Set the maximum inactivity time on the client side. Defaults to milliseconds. Valid suffixes d, h, m, s, ms, us',
        default: '',
    },
    tuning_timeout_http_req: {
      type: 'String',
        desc: 'Set the maximum allowed time to wait for a complete HTTP request. Defaults to milliseconds. Valid suffixes d, h, m, s, ms, us',
        default: '',
    },
    tuning_timeout_http_keep_alive: {
      type: 'String',
        desc: 'Set the maximum allowed time to wait for a new HTTP request to appear. Defaults to milliseconds. Valid suffixes d, h, m, s, ms, us',
        default: '',
    },
    linked_cpu_affinity_rules: {
      type: 'Array[String]',
        desc: 'Choose CPU affinity rules that should be applied to this public service.',
        default: []
    },
    logging_dont_log_null: {
      type: 'Boolean',
        desc: 'Enable or disable logging of connections with no data.',
        default: true
    },
    logging_dont_log_normal: {
      type: 'Boolean',
        desc: 'Enable or disable logging of normal, successful connections.',
        default: true
    },
    logging_log_separate_errors: {
      type: 'Boolean',
        desc: 'Allow HAProxy to automatically raise log level for non-completely successful connections to aid debugging.',
        default: true
    },
    logging_detailed_log: {
      type: 'Boolean',
        desc: 'Enable or disable verbose logging. Each log line turns into a much richer format.',
        default: true
    },
    logging_socket_stats: {
      type: 'Boolean',
        desc: 'Enable or disable collecting & providing separate statistics for each socket.',
        default: true
    },
    stickiness_pattern: {
      type: "Enum['', 'ipv4', 'ipv6', 'integer', 'string', 'binary']",
        desc: 'Choose the type of data that should be stored in this stick-table.',
        default: '',
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
        desc: 'This configures the maximum duration of an entry in the stick-table since it was last created, refreshed or matched. Valid suffixes d, h, m, s, ms.',
        default: '30m'
    },
    stickiness_size: {
      type: 'String',
        desc: 'This configures the maximum number of entries that can fit in the table. Valid suffixes k, m, g.',
        default: '50k'
    },
    stickiness_counter: {
      type: 'Boolean',
        desc: 'Enable to be able to retrieve values from sticky counters.',
        default: true
    },
    stickiness_counter_key: {
      type: 'String',
        desc: 'Describes what elements of the incoming request or connection will be analyzed, extracted, combined, and used to select which table entry to update the counters.',
        default: 'src'
    },
    stickiness_length: {
      type: 'String',
        desc: 'Specify the maximum length for a value in the stick-table.',
        default: ''
    },
    stickiness_conn_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '10s'
    },
    stickiness_sess_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '10s'
    },
    stickiness_http_req_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '10s'
    },
    stickiness_http_err_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '10s'
    },
    stickiness_bytes_in_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '1m'
    },
    stickiness_bytes_out_rate_period: {
      type: 'String',
        desc: 'The length of the period over which the average is measured. Valid suffixes d, h, m, s, ms, us',
        default: '1m'
    },
    http2_enabled: {
      type: 'Boolean',
        desc: 'Enable support for HTTP/2.',
        default: true
    },
    http2_enabled_nontls: {
      type: 'Boolean',
        desc: 'Enable support for HTTP/2 even if TLS (SSL offloading) is not enabled.',
        default: true
    },
    advertised_protocols: {
      type: "Array[Enum['', 'h2', 'http11', 'http10']]",
        desc: 'When using the TLS ALPN extension, HAProxy advertises the specified protocol list as supported on top of ALPN.',
        default: ['h2', 'http11'],
    },
    forward_for: {
      type: 'Boolean',
        desc: 'Enable insertion of the X-Forwarded-For header to requests sent to servers.',
        default: true
    },
    connection_behaviour: {
      type: "Enum['http-keep-alive', 'http-tunnel', 'httpclose', 'http-server-close', 'forceclose']",
        desc: 'The HaProxy connection behaviour.',
        default: 'http-keep-alive',
    },
    custom_options: {
      type: 'String',
        desc: 'These lines will be added to the HAProxy frontend configuration.',
        default: ''
    },
    linked_actions: {
      type: 'Array[String]',
        desc: 'Choose uuid of rules to be included in this public service.',
        default: []
    },
    linked_errorfiles: {
      type: 'Array[String]',
        desc: 'Choose uuid of error messages to be included in this public service.',
        default: []
    },
  },
)
