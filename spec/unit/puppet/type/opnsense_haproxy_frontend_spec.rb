# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_haproxy_frontend'

RSpec.describe 'the opnsense_haproxy_frontend type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_haproxy_frontend)).not_to be_nil
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:opnsense_haproxy_frontend).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'example haproxy frontend on opnsense.example.com' do
    let(:frontend) do
        Puppet::Type.type(:opnsense_haproxy_frontend).new(
            name: 'webserver_frontend',
            device: 'opnsense-test.device.com',
            enabled: true,
            description: 'frontend for webserver',
            bind: '127.0.0.1:8080',
            bind_options: '',
            mode: 'http',
            default_backend: '',
            ssl_enabled: true,
            ssl_certificates: ['60cc4641eb577', '5eba6f0f352e3'],
            ssl_default_certificate: '60cc4641eb577',
            ssl_custom_options: '',
            ssl_advanced_enabled: true,
            ssl_bind_options: ['prefer-client-ciphers'],
            ssl_min_version: 'TLSv1.2',
            ssl_max_version: '',
            ssl_cipher_list: ('ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:'
                             'ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:'
                             'ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256'),
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
            stickiness_data_types: [''],
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
            advertised_protocols: ['h2', 'http11'],
            forward_for: true,
            connection_behaviour: 'http-keep-alive',
            custom_options: '',
            linked_actions: [],
            linked_errorfiles: [],
            ensure: 'present',
        )
    end
  
    it 'accepts enabled' do
      frontend[:enabled] = false
      expect(frontend[:enabled]).to eq(:false)
    end

    it 'accepts a description' do
      frontend[:description] = 'modified example'
      expect(frontend[:description]).to eq('modified example')
    end

    it 'accepts bind' do
      frontend[:bind] = '127.0.0.1:8081'
      expect(frontend[:bind]).to eq('127.0.0.1:8081')
    end

    it 'accepts bind_options' do
      frontend[:bind_options] = 'accept-proxy npn http/1.1'
      expect(frontend[:bind_options]).to eq('accept-proxy npn http/1.1')
    end

    it 'accepts mode' do
      frontend[:mode] = 'ssl'
      expect(frontend[:mode]).to eq('ssl')
    end

    it 'accepts a default_backend' do
      frontend[:default_backend] = '5f29ba6e-7bea-4530-b2fd-d3f843e0ef2f'
      expect(frontend[:default_backend]).to eq('5f29ba6e-7bea-4530-b2fd-d3f843e0ef2f')
    end

    it 'accepts ssl_enabled' do
      frontend[:ssl_enabled] = false
      expect(frontend[:ssl_enabled]).to eq(:false)
    end

    it 'accepts ssl_certificates' do
      frontend[:ssl_certificates] = ['60cc4641eb577']
      expect(frontend[:ssl_certificates]).to eq(['60cc4641eb577'])
    end

    it 'accepts ssl_default_certificate' do
      frontend[:ssl_default_certificate] = '60cc4641eb577'
      expect(frontend[:ssl_default_certificate]).to eq('60cc4641eb577')
    end

    it 'accepts ssl_custom_options' do
      frontend[:ssl_custom_options] = 'ssl-max-ver SSLv3'
      expect(frontend[:ssl_custom_options]).to eq('ssl-max-ver SSLv3')
    end

    it 'accepts ssl_advanced_enabled' do
      frontend[:ssl_advanced_enabled] = false
      expect(frontend[:ssl_advanced_enabled]).to eq(:false)
    end

    it 'accepts ssl_bind_options' do
      frontend[:ssl_bind_options] = ['prefer-client-ciphers', 'force-sslv3']
      expect(frontend[:ssl_bind_options]).to eq(['prefer-client-ciphers', 'force-sslv3'])
    end

    it 'accepts ssl_min_version' do
      frontend[:ssl_min_version] = 'TLSv1.1'
      expect(frontend[:ssl_min_version]).to eq('TLSv1.1')
    end

    it 'accepts ssl_max_version' do
      frontend[:ssl_max_version] = 'SSLv3'
      expect(frontend[:ssl_max_version]).to eq('SSLv3')
    end

    it 'accepts ssl_cipher_list' do
      frontend[:ssl_cipher_list] = 'ECDHE-ECDSA-AES256-GCM-SHA384'
      expect(frontend[:ssl_cipher_list]).to eq('ECDHE-ECDSA-AES256-GCM-SHA384')
    end

    it 'accepts ssl_cipher_suites' do
      frontend[:ssl_cipher_suites] = 'TLS_AES_128_GCM_SHA256'
      expect(frontend[:ssl_cipher_suites]).to eq('TLS_AES_128_GCM_SHA256')
    end

    it 'accepts ssl_hsts_enabled' do
      frontend[:ssl_hsts_enabled] = false
      expect(frontend[:ssl_hsts_enabled]).to eq(:false)
    end

    it 'accepts ssl_hsts_include_sub_domains' do
      frontend[:ssl_hsts_include_sub_domains] = false
      expect(frontend[:ssl_hsts_include_sub_domains]).to eq(:false)
    end

    it 'accepts ssl_hsts_preload' do
      frontend[:ssl_hsts_preload] = false
      expect(frontend[:ssl_hsts_preload]).to eq(:false)
    end

    it 'accepts ssl_hsts_max_age' do
      frontend[:ssl_hsts_max_age] = '15768500'
      expect(frontend[:ssl_hsts_max_age]).to eq('15768500')
    end

    it 'accepts ssl_client_auth_enabled' do
      frontend[:ssl_client_auth_enabled] = false
      expect(frontend[:ssl_client_auth_enabled]).to eq(:false)
    end

    it 'accepts ssl_client_auth_verify' do
      frontend[:ssl_client_auth_verify] = 'optional'
      expect(frontend[:ssl_client_auth_verify]).to eq('optional')
    end

    it 'accepts ssl_client_auth_cas' do
      frontend[:ssl_client_auth_cas] = ['5eba6f0f352e3']
      expect(frontend[:ssl_client_auth_cas]).to eq(['5eba6f0f352e3'])
    end

    it 'accepts ssl_client_auth_crls' do
      frontend[:ssl_client_auth_crls] = ['5eba6f0f352e3']
      expect(frontend[:ssl_client_auth_crls]).to eq(['5eba6f0f352e3'])
    end

    it 'accepts basic_auth_enabled' do
      frontend[:basic_auth_enabled] = false
      expect(frontend[:basic_auth_enabled]).to eq(:false)
    end

    it 'accepts basic_auth_users' do
      frontend[:basic_auth_users] = ['f12d0e44-975d-4f30-a3ee-dca4f0079c77']
      expect(frontend[:basic_auth_users]).to eq(['f12d0e44-975d-4f30-a3ee-dca4f0079c77'])
    end

    it 'accepts basic_auth_groups' do
      frontend[:basic_auth_groups] = ['39cd97c9-c734-46c8-955e-d227b03985b0']
      expect(frontend[:basic_auth_groups]).to eq(['39cd97c9-c734-46c8-955e-d227b03985b0'])
    end

    it 'accepts tuning_max_connections' do
      frontend[:tuning_max_connections] = '50'
      expect(frontend[:tuning_max_connections]).to eq('50')
    end

    it 'accepts tuning_timeout_client' do
      frontend[:tuning_timeout_client] = '60s'
      expect(frontend[:tuning_timeout_client]).to eq('60s')
    end

    it 'accepts tuning_timeout_http_req' do
      frontend[:tuning_timeout_http_req] = '60s'
      expect(frontend[:tuning_timeout_http_req]).to eq('60s')
    end

    it 'accepts tuning_timeout_http_keep_alive' do
      frontend[:tuning_timeout_http_keep_alive] = '60s'
      expect(frontend[:tuning_timeout_http_keep_alive]).to eq('60s')
    end

    it 'accepts linked_cpu_affinity_rules' do
      frontend[:linked_cpu_affinity_rules] = ['0e4748b9-d435-4c95-9f1d-3f76650e2a29']
      expect(frontend[:linked_cpu_affinity_rules]).to eq(['0e4748b9-d435-4c95-9f1d-3f76650e2a29'])
    end

    it 'accepts logging_dont_log_null' do
      frontend[:logging_dont_log_null] = false
      expect(frontend[:logging_dont_log_null]).to eq(:false)
    end

    it 'accepts logging_dont_log_normal' do
      frontend[:logging_dont_log_normal] = false
      expect(frontend[:logging_dont_log_normal]).to eq(:false)
    end

    it 'accepts logging_log_separate_errors' do
      frontend[:logging_log_separate_errors] = false
      expect(frontend[:logging_log_separate_errors]).to eq(:false)
    end

    it 'accepts logging_detailed_log' do
      frontend[:logging_detailed_log] = false
      expect(frontend[:logging_detailed_log]).to eq(:false)
    end

    it 'accepts logging_socket_stats' do
      frontend[:logging_socket_stats] = false
      expect(frontend[:logging_socket_stats]).to eq(:false)
    end

    it 'accepts stickiness_pattern' do
      frontend[:stickiness_pattern] = 'ipv4'
      expect(frontend[:stickiness_pattern]).to eq('ipv4')
    end

    it 'accepts stickiness_data_types' do
      frontend[:stickiness_data_types] = ['conn_rate', 'sess_cnt']
      expect(frontend[:stickiness_data_types]).to eq(['conn_rate', 'sess_cnt'])
    end

    it 'accepts stickiness_expire' do
      frontend[:stickiness_expire] = '40m'
      expect(frontend[:stickiness_expire]).to eq('40m')
    end

    it 'accepts stickiness_size' do
      frontend[:stickiness_size] = '40k'
      expect(frontend[:stickiness_size]).to eq('40k')
    end

    it 'accepts stickiness_counter' do
      frontend[:stickiness_counter] = false
      expect(frontend[:stickiness_counter]).to eq(:false)
    end

    it 'accepts stickiness_counter_key' do
      frontend[:stickiness_counter_key] = 'path'
      expect(frontend[:stickiness_counter_key]).to eq('path')
    end

    it 'accepts stickiness_length' do
      frontend[:stickiness_length] = '100'
      expect(frontend[:stickiness_length]).to eq('100')
    end

    it 'accepts stickiness_conn_rate_period' do
      frontend[:stickiness_conn_rate_period] = '20s'
      expect(frontend[:stickiness_conn_rate_period]).to eq('20s')
    end

    it 'accepts stickiness_sess_rate_period' do
      frontend[:stickiness_sess_rate_period] = '20s'
      expect(frontend[:stickiness_sess_rate_period]).to eq('20s')
    end

    it 'accepts stickiness_http_req_rate_period' do
      frontend[:stickiness_http_req_rate_period] = '20s'
      expect(frontend[:stickiness_http_req_rate_period]).to eq('20s')
    end

    it 'accepts stickiness_http_err_rate_period' do
      frontend[:stickiness_http_err_rate_period] = '20s'
      expect(frontend[:stickiness_http_err_rate_period]).to eq('20s')
    end

    it 'accepts stickiness_bytes_in_rate_period' do
      frontend[:stickiness_bytes_in_rate_period] = '2m'
      expect(frontend[:stickiness_bytes_in_rate_period]).to eq('2m')
    end

    it 'accepts stickiness_bytes_out_rate_period' do
      frontend[:stickiness_bytes_out_rate_period] = '2m'
      expect(frontend[:stickiness_bytes_out_rate_period]).to eq('2m')
    end

    it 'accepts http2_enabled' do
      frontend[:http2_enabled] = false
      expect(frontend[:http2_enabled]).to eq(:false)
    end

    it 'accepts http2_enabled_nontls' do
      frontend[:http2_enabled_nontls] = false
      expect(frontend[:http2_enabled_nontls]).to eq(:false)
    end

    it 'accepts advertised_protocols' do
      frontend[:advertised_protocols] = ['http11', 'http10']
      expect(frontend[:advertised_protocols]).to eq(['http11', 'http10'])
    end

    it 'accepts forward_for' do
      frontend[:forward_for] = false
      expect(frontend[:forward_for]).to eq(:false)
    end

    it 'accepts connection_behaviour' do
      frontend[:connection_behaviour] = 'http-tunnel'
      expect(frontend[:connection_behaviour]).to eq('http-tunnel')
    end

    it 'accepts custom_options' do
      frontend[:custom_options] = 'http-request redirect scheme https'
      expect(frontend[:custom_options]).to eq('http-request redirect scheme https')
    end

    it 'accepts linked_actions' do
      frontend[:linked_actions] = ['2e63c41e-fa87-44bd-96cf-c10303c795af']
      expect(frontend[:linked_actions]).to eq(['2e63c41e-fa87-44bd-96cf-c10303c795af'])
    end

    it 'accepts linked_errorfiles' do
      frontend[:linked_errorfiles] = ['1e63c41e-fa87-44bd-96cf-c10303c795af']
      expect(frontend[:linked_errorfiles]).to eq(['1e63c41e-fa87-44bd-96cf-c10303c795af'])
    end
  end
end
