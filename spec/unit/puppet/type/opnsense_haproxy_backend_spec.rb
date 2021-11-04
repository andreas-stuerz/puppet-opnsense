# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_haproxy_backend'

RSpec.describe 'the opnsense_haproxy_backend type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_haproxy_backend)).not_to be_nil
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:opnsense_haproxy_backend).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'example haproxy backend on opnsense.example.com' do
    let(:backend) do
      Puppet::Type.type(:opnsense_haproxy_backend).new(
          name: 'webserver_pool',
          device: 'opnsense-test.device.com',
          enabled: true,
          description: 'backend for webserver',
          mode: 'http',
          algorithm: 'source',
          random_draws: '2',
          proxy_protocol: '',
          linked_servers: [],
          linked_resolver: '',
          resolver_opts: [],
          resolve_prefer: '',
          source: '',
          health_check_enabled: true,
          health_check: '',
          health_check_log_status: true,
          check_interval: '',
          check_down_interval: '',
          health_check_fall: '',
          health_check_rise: '',
          linked_mailer: '',
          http2_enabled: true,
          http2_enabled_nontls: true,
          ba_advertised_protocols: ['h2', 'http11'],
          persistence: 'sticktable',
          persistence_cookiemode: 'piggyback',
          persistence_cookiename: 'SRVCOOKIE',
          persistence_stripquotes: true,
          stickiness_pattern: 'sourceipv4',
          stickiness_data_types: ['bytes_in_cnt', 'bytes_out_cnt'],
          stickiness_expire: '30m',
          stickiness_size: '50k',
          stickiness_cookiename: '',
          stickiness_cookielength: '',
          stickiness_conn_rate_period: '10s',
          stickiness_sess_rate_period: '10s',
          stickiness_http_req_rate_period: '10s',
          stickiness_http_err_rate_period: '10s',
          stickiness_bytes_in_rate_period: '1m',
          stickiness_bytes_out_rate_period: '1m',
          basic_auth_enabled: true,
          basic_auth_users: [],
          basic_auth_groups: [],
          tuning_timeout_connect: '',
          tuning_timeout_check: '',
          tuning_timeout_server: '',
          tuning_retries: '',
          custom_options: '',
          tuning_defaultserver: '',
          tuning_noport: true,
          tuning_httpreuse: 'safe',
          tuning_caching: true,
          linked_actions: [],
          linked_errorfiles: [],
          ensure: 'present',
        )
    end

    it 'accepts enabled' do
      backend[:enabled] = false
      expect(backend[:enabled]).to eq(:false)
    end

    it 'accepts a description' do
      backend[:description] = 'modified example'
      expect(backend[:description]).to eq('modified example')
    end

    it 'accepts a mode' do
      backend[:mode] = 'tcp'
      expect(backend[:mode]).to eq('tcp')
    end

    it 'accepts a algorithm' do
      backend[:algorithm] = 'roundrobin'
      expect(backend[:algorithm]).to eq('roundrobin')
    end

    it 'accepts random_draws' do
      backend[:random_draws] = '3'
      expect(backend[:random_draws]).to eq('3')
    end

    it 'accepts a proxy_protocol' do
      backend[:proxy_protocol] = 'v1'
      expect(backend[:proxy_protocol]).to eq('v1')
    end

    it 'accepts linked_servers' do
      backend[:linked_servers] = ['5f29ba6e-7bea-4530-b2fd-d3f843e0ef2f']
      expect(backend[:linked_servers]).to eq(['5f29ba6e-7bea-4530-b2fd-d3f843e0ef2f'])
    end

    it 'accepts a linked_resolver' do
      backend[:linked_resolver] = '1bb178dc-f8a2-41ab-a054-ebfc6b577cb3'
      expect(backend[:linked_resolver]).to eq('1bb178dc-f8a2-41ab-a054-ebfc6b577cb3')
    end

    it 'accepts resolver_opts' do
      backend[:resolver_opts] = ['allow-dup-ip']
      expect(backend[:resolver_opts]).to eq(['allow-dup-ip'])
    end

    it 'accepts a resolve_prefer' do
      backend[:resolve_prefer] = 'ipv4'
      expect(backend[:resolve_prefer]).to eq('ipv4')
    end

    it 'accepts a source' do
      backend[:source] = '10.0.0.2'
      expect(backend[:source]).to eq('10.0.0.2')
    end

    it 'accepts health_check_enabled' do
      backend[:health_check_enabled] = false
      expect(backend[:health_check_enabled]).to eq(:false)
    end

    it 'accepts a health_check' do
      backend[:health_check] = '2de2e820-adee-40ea-b6ee-c6babe730133'
      expect(backend[:health_check]).to eq('2de2e820-adee-40ea-b6ee-c6babe730133')
    end

    it 'accepts a health_check_log_status' do
      backend[:health_check_log_status] = false
      expect(backend[:health_check_log_status]).to eq(:false)
    end

    it 'accepts a check_interval' do
      backend[:check_interval] = '100'
      expect(backend[:check_interval]).to eq('100')
    end

    it 'accepts a check_down_interval' do
      backend[:check_down_interval] = '100'
      expect(backend[:check_down_interval]).to eq('100')
    end

    it 'accepts a health_check_fall' do
      backend[:health_check_fall] = '2'
      expect(backend[:health_check_fall]).to eq('2')
    end

    it 'accepts a health_check_rise' do
      backend[:health_check_rise] = '3'
      expect(backend[:health_check_rise]).to eq('3')
    end

    it 'accepts a linked_mailer' do
      backend[:linked_mailer] = 'baaeabff-08c9-4131-932a-b9b157a432cd'
      expect(backend[:linked_mailer]).to eq('baaeabff-08c9-4131-932a-b9b157a432cd')
    end

    it 'accepts a http2_enabled' do
      backend[:http2_enabled] = false
      expect(backend[:http2_enabled]).to eq(:false)
    end

    it 'accepts a http2_enabled_nontls' do
      backend[:http2_enabled_nontls] = false
      expect(backend[:http2_enabled_nontls]).to eq(:false)
    end

    it 'accepts a ba_advertised_protocols' do
      backend[:ba_advertised_protocols] = ['http11']
      expect(backend[:ba_advertised_protocols]).to eq(['http11'])
    end

    it 'accepts a persistence' do
      backend[:persistence] = 'cookie'
      expect(backend[:persistence]).to eq('cookie')
    end

    it 'accepts a persistence_cookiemode' do
      backend[:persistence_cookiemode] = 'new'
      expect(backend[:persistence_cookiemode]).to eq('new')
    end

    it 'accepts a persistence_cookiename' do
      backend[:persistence_cookiename] = 'COOKIE'
      expect(backend[:persistence_cookiename]).to eq('COOKIE')
    end

    it 'accepts a persistence_stripquotes' do
      backend[:persistence_stripquotes] = false
      expect(backend[:persistence_stripquotes]).to eq(:false)
    end

    it 'accepts a stickiness_pattern' do
      backend[:stickiness_pattern] = 'sourceipv6'
      expect(backend[:stickiness_pattern]).to eq('sourceipv6')
    end

    it 'accepts a stickiness_data_types' do
      backend[:stickiness_data_types] = ['conn_cnt']
      expect(backend[:stickiness_data_types]).to eq(['conn_cnt'])
    end

    it 'accepts a stickiness_expire' do
      backend[:stickiness_expire] = '20m'
      expect(backend[:stickiness_expire]).to eq('20m')
    end

    it 'accepts a stickiness_cookiename' do
      backend[:stickiness_cookiename] = 'cookie2'
      expect(backend[:stickiness_cookiename]).to eq('cookie2')
    end

    it 'accepts a stickiness_cookielength' do
      backend[:stickiness_cookielength] = '20'
      expect(backend[:stickiness_cookielength]).to eq('20')
    end

    it 'accepts a stickiness_conn_rate_period' do
      backend[:stickiness_conn_rate_period] = '20s'
      expect(backend[:stickiness_conn_rate_period]).to eq('20s')
    end

    it 'accepts a stickiness_sess_rate_period' do
      backend[:stickiness_sess_rate_period] = '20s'
      expect(backend[:stickiness_sess_rate_period]).to eq('20s')
    end

    it 'accepts a stickiness_http_req_rate_period' do
      backend[:stickiness_http_req_rate_period] = '20s'
      expect(backend[:stickiness_http_req_rate_period]).to eq('20s')
    end

    it 'accepts a stickiness_http_err_rate_period' do
      backend[:stickiness_http_err_rate_period] = '20s'
      expect(backend[:stickiness_http_err_rate_period]).to eq('20s')
    end

    it 'accepts a stickiness_bytes_in_rate_period' do
      backend[:stickiness_bytes_in_rate_period] = '2m'
      expect(backend[:stickiness_bytes_in_rate_period]).to eq('2m')
    end

    it 'accepts a stickiness_bytes_out_rate_period' do
      backend[:stickiness_bytes_out_rate_period] = '2m'
      expect(backend[:stickiness_bytes_out_rate_period]).to eq('2m')
    end

    it 'accepts a basic_auth_enabled' do
      backend[:basic_auth_enabled] = false
      expect(backend[:basic_auth_enabled]).to eq(:false)
    end

    it 'accepts basic_auth_users' do
      backend[:basic_auth_users] = ['f12d0e44-975d-4f30-a3ee-dca4f0079c77']
      expect(backend[:basic_auth_users]).to eq(['f12d0e44-975d-4f30-a3ee-dca4f0079c77'])
    end

    it 'accepts a basic_auth_groups' do
      backend[:basic_auth_groups] = ['39cd97c9-c734-46c8-955e-d227b03985b0']
      expect(backend[:basic_auth_groups]).to eq(['39cd97c9-c734-46c8-955e-d227b03985b0'])
    end

    it 'accepts a tuning_timeout_connect' do
      backend[:tuning_timeout_connect] = '20s'
      expect(backend[:tuning_timeout_connect]).to eq('20s')
    end

    it 'accepts a tuning_timeout_check' do
      backend[:tuning_timeout_check] = '20s'
      expect(backend[:tuning_timeout_check]).to eq('20s')
    end

    it 'accepts a tuning_timeout_server' do
      backend[:tuning_timeout_server] = '20s'
      expect(backend[:tuning_timeout_server]).to eq('20s')
    end

    it 'accepts a tuning_retries' do
      backend[:tuning_retries] = '20'
      expect(backend[:tuning_retries]).to eq('20')
    end

    it 'accepts custom_options' do
      backend[:custom_options] = 'http-reuse safe'
      expect(backend[:custom_options]).to eq('http-reuse safe')
    end

    it 'accepts a tuning_defaultserver' do
      backend[:tuning_defaultserver] = 'port 21'
      expect(backend[:tuning_defaultserver]).to eq('port 21')
    end

    it 'accepts a tuning_noport' do
      backend[:tuning_noport] = false
      expect(backend[:tuning_noport]).to eq(:false)
    end

    it 'accepts a tuning_httpreuse' do
      backend[:tuning_httpreuse] = 'never'
      expect(backend[:tuning_httpreuse]).to eq('never')
    end

    it 'accepts a tuning_caching' do
      backend[:tuning_caching] = false
      expect(backend[:tuning_caching]).to eq(:false)
    end

    it 'accepts linked_actions' do
      backend[:linked_actions] = ['0e4748b9-d435-4c95-9f1d-3f76650e2a29']
      expect(backend[:linked_actions]).to eq(['0e4748b9-d435-4c95-9f1d-3f76650e2a29'])
    end

    it 'accepts linked_errorfiles' do
      backend[:linked_errorfiles] = ['1e63c41e-fa87-44bd-96cf-c10303c795af']
      expect(backend[:linked_errorfiles]).to eq(['1e63c41e-fa87-44bd-96cf-c10303c795af'])
    end
  end
end
