# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsenseHaproxyFrontend')
require 'puppet/provider/opnsense_haproxy_frontend/opnsense_haproxy_frontend'

RSpec.describe Puppet::Provider::OpnsenseHaproxyFrontend::OpnsenseHaproxyFrontend do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }
  let(:frontends_device_1) do
    [
      {
        "id": '615e997a78e0f2.76779255',
          "enabled": '1',
          "name": 'database_frontend',
          "description": '',
          "bind": '127.0.0.1:8081',
          "bindOptions": '',
          "mode": 'tcp',
          "defaultBackend": '',
          "ssl_enabled": '1',
          "ssl_certificates": '60cc4641eb577',
          "ssl_default_certificate": '',
          "ssl_customOptions": '',
          "ssl_advancedEnabled": '1',
          "ssl_bindOptions": '',
          "ssl_minVersion": 'TLSv1.2',
          "ssl_maxVersion": '',
          "ssl_cipherList": 'ECDHE-ECDSA-AES256-GCM-SHA384',
          "ssl_cipherSuites": 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
          "ssl_hstsEnabled": '1',
          "ssl_hstsIncludeSubDomains": '1',
          "ssl_hstsPreload": '1',
          "ssl_hstsMaxAge": '15768000',
          "ssl_clientAuthEnabled": '1',
          "ssl_clientAuthVerify": 'required',
          "ssl_clientAuthCAs": '',
          "ssl_clientAuthCRLs": '',
          "basicAuthEnabled": '1',
          "basicAuthUsers": [],
          "basicAuthGroups": [],
          "tuning_maxConnections": '',
          "tuning_timeoutClient": '',
          "tuning_timeoutHttpReq": '',
          "tuning_timeoutHttpKeepAlive": '',
          "linkedCpuAffinityRules": [],
          "logging_dontLogNull": '1',
          "logging_dontLogNormal": '1',
          "logging_logSeparateErrors": '1',
          "logging_detailedLog": '1',
          "logging_socketStats": '1',
          "stickiness_pattern": '',
          "stickiness_dataTypes": '',
          "stickiness_expire": '30m',
          "stickiness_size": '50k',
          "stickiness_counter": '1',
          "stickiness_counter_key": 'src',
          "stickiness_length": '',
          "stickiness_connRatePeriod": '10s',
          "stickiness_sessRatePeriod": '10s',
          "stickiness_httpReqRatePeriod": '10s',
          "stickiness_httpErrRatePeriod": '10s',
          "stickiness_bytesInRatePeriod": '1m',
          "stickiness_bytesOutRatePeriod": '1m',
          "http2Enabled": '1',
          "http2Enabled_nontls": '1',
          "advertised_protocols": '',
          "forwardFor": '1',
          "connectionBehaviour": 'http-keep-alive',
          "customOptions": '',
          "linkedActions": [],
          "linkedErrorfiles": [],
          "uuid": '13ae6d97-6ee0-4855-bfa3-d894215d90ef',
          "Backend": '',
          "Users": '',
          "Groups": '',
          "Cpus": '',
          "Actions": '',
          "Errorfiles": ''
      },
    ]
  end
  let(:frontends_device_2) do
    [
      {
        "id": '715e997a78e0f2.77779255',
          "enabled": '1',
          "name": 'webserver_frontend',
          "description": '',
          "bind": '127.0.0.1:8085',
          "bindOptions": '',
          "mode": 'http',
          "defaultBackend": '',
          "ssl_enabled": '1',
          "ssl_certificates": '60cc4641eb577',
          "ssl_default_certificate": '',
          "ssl_customOptions": '',
          "ssl_advancedEnabled": '1',
          "ssl_bindOptions": '',
          "ssl_minVersion": 'TLSv1.2',
          "ssl_maxVersion": '',
          "ssl_cipherList": 'ECDHE-ECDSA-AES256-GCM-SHA384',
          "ssl_cipherSuites": 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
          "ssl_hstsEnabled": '1',
          "ssl_hstsIncludeSubDomains": '1',
          "ssl_hstsPreload": '1',
          "ssl_hstsMaxAge": '15768000',
          "ssl_clientAuthEnabled": '1',
          "ssl_clientAuthVerify": 'required',
          "ssl_clientAuthCAs": '',
          "ssl_clientAuthCRLs": '',
          "basicAuthEnabled": '1',
          "basicAuthUsers": [],
          "basicAuthGroups": [],
          "tuning_maxConnections": '',
          "tuning_timeoutClient": '',
          "tuning_timeoutHttpReq": '',
          "tuning_timeoutHttpKeepAlive": '',
          "linkedCpuAffinityRules": [],
          "logging_dontLogNull": '1',
          "logging_dontLogNormal": '1',
          "logging_logSeparateErrors": '1',
          "logging_detailedLog": '1',
          "logging_socketStats": '1',
          "stickiness_pattern": '',
          "stickiness_dataTypes": '',
          "stickiness_expire": '30m',
          "stickiness_size": '50k',
          "stickiness_counter": '1',
          "stickiness_counter_key": 'src',
          "stickiness_length": '',
          "stickiness_connRatePeriod": '10s',
          "stickiness_sessRatePeriod": '10s',
          "stickiness_httpReqRatePeriod": '10s',
          "stickiness_httpErrRatePeriod": '10s',
          "stickiness_bytesInRatePeriod": '1m',
          "stickiness_bytesOutRatePeriod": '1m',
          "http2Enabled": '1',
          "http2Enabled_nontls": '1',
          "advertised_protocols": '',
          "forwardFor": '1',
          "connectionBehaviour": 'http-keep-alive',
          "customOptions": '',
          "linkedActions": [],
          "linkedErrorfiles": [],
          "uuid": '13ae6d97-6ee0-4855-bfa3-d894215d90ef',
          "Backend": '',
          "Users": '',
          "Groups": '',
          "Cpus": '',
          "Actions": '',
          "Errorfiles": ''
      },
    ]
  end

  describe '#get' do
    it 'processes resources' do
      expect(Dir).to receive(:glob).and_return(devices)
      expect(Puppet::Util::Execution).to receive(:execute).with(
          [
            'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense1.example.com-config.yaml'),
            ['haproxy', 'frontend', 'list', '-o', 'json']
          ],
          { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
        ).and_return(frontends_device_1.to_json)
      expect(Puppet::Util::Execution).to receive(:execute).with(
          [
            'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense2.example.com-config.yaml'),
            ['haproxy', 'frontend', 'list', '-o', 'json']
          ],
          { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
        ).and_return(frontends_device_2.to_json)

      expect(provider.get(context, [])).to eq [
        {
          title: 'database_frontend@opnsense1.example.com',
            name: 'database_frontend',
            device: 'opnsense1.example.com',
            uuid: '13ae6d97-6ee0-4855-bfa3-d894215d90ef',
            enabled: true,
            description: '',
            bind: '127.0.0.1:8081',
            bind_options: '',
            mode: 'tcp',
            default_backend: '',
            ssl_enabled: true,
            ssl_certificates: ['60cc4641eb577'],
            ssl_default_certificate: '',
            ssl_custom_options: '',
            ssl_advanced_enabled: true,
            ssl_bind_options: [],
            ssl_min_version: 'TLSv1.2',
            ssl_max_version: '',
            ssl_cipher_list: 'ECDHE-ECDSA-AES256-GCM-SHA384',
            ssl_cipher_suites: 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
            ssl_hsts_enabled: true,
            ssl_hsts_include_sub_domains: true,
            ssl_hsts_preload: true,
            ssl_hsts_max_age: '15768000',
            ssl_client_auth_enabled: true,
            ssl_client_auth_verify: 'required',
            ssl_client_auth_cas: [],
            ssl_client_auth_crls: [],
            basic_auth_enabled: true,
            basic_auth_users: [],
            basic_auth_groups: [],
            tuning_max_connections: '',
            tuning_timeout_client: '',
            tuning_timeout_http_req: '',
            tuning_timeout_http_keep_alive: '',
            linked_cpu_affinity_rules: [],
            logging_dont_log_null: true,
            logging_dont_log_normal: true,
            logging_log_separate_errors: true,
            logging_detailed_log: true,
            logging_socket_stats: true,
            stickiness_pattern: '',
            stickiness_data_types: [],
            stickiness_expire: '30m',
            stickiness_size: '50k',
            stickiness_counter: true,
            stickiness_counter_key: 'src',
            stickiness_length: '',
            stickiness_conn_rate_period: '10s',
            stickiness_sess_rate_period: '10s',
            stickiness_http_req_rate_period: '10s',
            stickiness_http_err_rate_period: '10s',
            stickiness_bytes_in_rate_period: '1m',
            stickiness_bytes_out_rate_period: '1m',
            http2_enabled: true,
            http2_enabled_nontls: true,
            advertised_protocols: [],
            forward_for: true,
            connection_behaviour: 'http-keep-alive',
            custom_options: '',
            linked_actions: [],
            linked_errorfiles: [],
            ensure: 'present'
        },
        {
          title: 'webserver_frontend@opnsense2.example.com',
            name: 'webserver_frontend',
            device: 'opnsense2.example.com',
            uuid: '13ae6d97-6ee0-4855-bfa3-d894215d90ef',
            enabled: true,
            description: '',
            bind: '127.0.0.1:8085',
            bind_options: '',
            mode: 'http',
            default_backend: '',
            ssl_enabled: true,
            ssl_certificates: ['60cc4641eb577'],
            ssl_default_certificate: '',
            ssl_custom_options: '',
            ssl_advanced_enabled: true,
            ssl_bind_options: [],
            ssl_min_version: 'TLSv1.2',
            ssl_max_version: '',
            ssl_cipher_list: 'ECDHE-ECDSA-AES256-GCM-SHA384',
            ssl_cipher_suites: 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
            ssl_hsts_enabled: true,
            ssl_hsts_include_sub_domains: true,
            ssl_hsts_preload: true,
            ssl_hsts_max_age: '15768000',
            ssl_client_auth_enabled: true,
            ssl_client_auth_verify: 'required',
            ssl_client_auth_cas: [],
            ssl_client_auth_crls: [],
            basic_auth_enabled: true,
            basic_auth_users: [],
            basic_auth_groups: [],
            tuning_max_connections: '',
            tuning_timeout_client: '',
            tuning_timeout_http_req: '',
            tuning_timeout_http_keep_alive: '',
            linked_cpu_affinity_rules: [],
            logging_dont_log_null: true,
            logging_dont_log_normal: true,
            logging_log_separate_errors: true,
            logging_detailed_log: true,
            logging_socket_stats: true,
            stickiness_pattern: '',
            stickiness_data_types: [],
            stickiness_expire: '30m',
            stickiness_size: '50k',
            stickiness_counter: true,
            stickiness_counter_key: 'src',
            stickiness_length: '',
            stickiness_conn_rate_period: '10s',
            stickiness_sess_rate_period: '10s',
            stickiness_http_req_rate_period: '10s',
            stickiness_http_err_rate_period: '10s',
            stickiness_bytes_in_rate_period: '1m',
            stickiness_bytes_out_rate_period: '1m',
            http2_enabled: true,
            http2_enabled_nontls: true,
            advertised_protocols: [],
            forward_for: true,
            connection_behaviour: 'http-keep-alive',
            custom_options: '',
            linked_actions: [],
            linked_errorfiles: [],
            ensure: 'present'
        },
      ]
    end
  end

  describe 'create(context, name, should)' do
    it 'creates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved", "uuid": "1a2d6a8e-ed7a-4377-b723-e1582b2b2c18"}')

      provider.create(context, 'example_frontend@opnsense2.example.com',
                      enabled: true,
                      description: 'frontend for webserver',
                      bind: '127.0.0.1:8085',
                      bind_options: '',
                      mode: 'http',
                      default_backend: '',
                      ssl_enabled: true,
                      ssl_certificates: ['60cc4641eb577'],
                      ssl_default_certificate: '',
                      ssl_custom_options: '',
                      ssl_advanced_enabled: true,
                      ssl_bind_options: [],
                      ssl_min_version: 'TLSv1.2',
                      ssl_max_version: '',
                      ssl_cipher_list: 'ECDHE-ECDSA-AES256-GCM-SHA384',
                      ssl_cipher_suites: 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
                      ssl_hsts_enabled: true,
                      ssl_hsts_include_sub_domains: true,
                      ssl_hsts_preload: true,
                      ssl_hsts_max_age: '15768000',
                      ssl_client_auth_enabled: true,
                      ssl_client_auth_verify: 'required',
                      ssl_client_auth_cas: [],
                      ssl_client_auth_crls: [],
                      basic_auth_enabled: true,
                      basic_auth_users: [],
                      basic_auth_groups: [],
                      tuning_max_connections: '',
                      tuning_timeout_client: '',
                      tuning_timeout_http_req: '',
                      tuning_timeout_http_keep_alive: '',
                      linked_cpu_affinity_rules: [],
                      logging_dont_log_null: true,
                      logging_dont_log_normal: true,
                      logging_log_separate_errors: true,
                      logging_detailed_log: true,
                      logging_socket_stats: true,
                      stickiness_pattern: '',
                      stickiness_data_types: [],
                      stickiness_expire: '30m',
                      stickiness_size: '50k',
                      stickiness_counter: true,
                      stickiness_counter_key: 'src',
                      stickiness_length: '',
                      stickiness_conn_rate_period: '10s',
                      stickiness_sess_rate_period: '10s',
                      stickiness_http_req_rate_period: '10s',
                      stickiness_http_err_rate_period: '10s',
                      stickiness_bytes_in_rate_period: '1m',
                      stickiness_bytes_out_rate_period: '1m',
                      http2_enabled: true,
                      http2_enabled_nontls: true,
                      advertised_protocols: [],
                      forward_for: true,
                      connection_behaviour: 'http-keep-alive',
                      custom_options: '',
                      linked_actions: [],
                      linked_errorfiles: [],
                      ensure: 'present')
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return('{"result": "saved"}')
      frontends_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = frontends_device_2

      provider.update(context, { name: 'example_frontend', device: 'opnsense2.example.com' },
                      enabled: true,
                      description: 'frontend for webserver modified',
                      bind: '127.0.0.1:8081',
                      bind_options: 'accept-proxy npn http/1.1',
                      mode: 'ssl',
                      default_backend: '5f29ba6e-7bea-4530-b2fd-d3f843e0ef2f',
                      ssl_enabled: false,
                      ssl_certificates: ['5eba6f0f352e3'],
                      ssl_default_certificate: '5eba6f0f352e3',
                      ssl_custom_options: 'ssl-max-ver SSLv3',
                      ssl_advanced_enabled: false,
                      ssl_bind_options: [],
                      ssl_min_version: 'TLSv1.2',
                      ssl_max_version: '',
                      ssl_cipher_list: 'ECDHE-ECDSA-AES256-GCM-SHA384',
                      ssl_cipher_suites: 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
                      ssl_hsts_enabled: true,
                      ssl_hsts_include_sub_domains: true,
                      ssl_hsts_preload: true,
                      ssl_hsts_max_age: '15768000',
                      ssl_client_auth_enabled: true,
                      ssl_client_auth_verify: 'required',
                      ssl_client_auth_cas: [],
                      ssl_client_auth_crls: [],
                      basic_auth_enabled: true,
                      basic_auth_users: [],
                      basic_auth_groups: [],
                      tuning_max_connections: '',
                      tuning_timeout_client: '',
                      tuning_timeout_http_req: '',
                      tuning_timeout_http_keep_alive: '',
                      linked_cpu_affinity_rules: [],
                      logging_dont_log_null: true,
                      logging_dont_log_normal: true,
                      logging_log_separate_errors: true,
                      logging_detailed_log: true,
                      logging_socket_stats: true,
                      stickiness_pattern: '',
                      stickiness_data_types: [],
                      stickiness_expire: '30m',
                      stickiness_size: '50k',
                      stickiness_counter: true,
                      stickiness_counter_key: 'src',
                      stickiness_length: '',
                      stickiness_conn_rate_period: '10s',
                      stickiness_sess_rate_period: '10s',
                      stickiness_http_req_rate_period: '10s',
                      stickiness_http_err_rate_period: '10s',
                      stickiness_bytes_in_rate_period: '1m',
                      stickiness_bytes_out_rate_period: '1m',
                      http2_enabled: true,
                      http2_enabled_nontls: true,
                      advertised_protocols: [],
                      forward_for: true,
                      connection_behaviour: 'http-keep-alive',
                      custom_options: '',
                      linked_actions: [],
                      linked_errorfiles: [],
                      ensure: 'present')
    end
  end

  describe 'delete(context, name)' do
    it 'deletes the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return('{"result": "deleted"}')
      frontends_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = frontends_device_2

      provider.delete(context, { name: 'example_frontend', device: 'opnsense2.example.com' })
    end
  end
end
