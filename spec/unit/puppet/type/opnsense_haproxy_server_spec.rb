# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_haproxy_server'

RSpec.describe 'the opnsense_haproxy_server type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_haproxy_server)).not_to be_nil
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:opnsense_haproxy_server).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'example haproxy server on opnsense.example.com' do
    let(:server) do
      Puppet::Type.type(:opnsense_haproxy_server).new(
          name: 'webserver1',
          device: 'opnsense.example.com',
          enabled: true,
          description: 'primary webserver',
          address: 'webserver1.example.com',
          port: '443',
          checkport: '80',
          mode: 'active',
          type: 'static',
          service_name: '',
          linked_resolver: '',
          resolver_opts: ['allow-dup-ip', 'ignore-weight', 'prevent-dup-ip'],
          resolve_prefer: 'ipv4',
          ssl: true,
          ssl_verify: true,
          ssl_ca: ['60cc45d3d7530', '610d3779926d6'],
          ssl_crl: [],
          ssl_client_certificate: '60cc4641eb577',
          weight: '10',
          check_interval: '100',
          check_down_interval: '200',
          source: '10.0.0.1',
          advanced: 'send-proxy',
          ensure: 'present',
        )
    end

    it 'accepts enabled' do
      server[:enabled] = false
      expect(server[:enabled]).to eq(:false)
    end

    it 'accepts a description' do
      server[:description] = 'modified example'
      expect(server[:description]).to eq('modified example')
    end

    it 'accepts a address' do
      server[:address] = 'webserver1.example.de'
      expect(server[:address]).to eq('webserver1.example.de')
    end

    it 'accepts a port' do
      server[:port] = '80'
      expect(server[:port]).to eq('80')
    end

    it 'accepts a checkport' do
      server[:checkport] = '443'
      expect(server[:checkport]).to eq('443')
    end

    it 'accepts a mode' do
      server[:mode] = 'backup'
      expect(server[:mode]).to eq('backup')
    end

    it 'accepts a type' do
      server[:type] = 'template'
      expect(server[:type]).to eq('template')
    end

    it 'accepts a serviceName' do
      server[:service_name] = '_myservice._tcp.example.local'
      expect(server[:service_name]).to eq('_myservice._tcp.example.local')
    end

    it 'accepts a linkedResolver' do
      server[:linked_resolver] = 'cea8f031-9aba-4f6e-86c2-f5f5f27a10b8'
      expect(server[:linked_resolver]).to eq('cea8f031-9aba-4f6e-86c2-f5f5f27a10b8')
    end

    it 'accepts a resolverOpts' do
      server[:resolver_opts] = ['allow-dup-ip']
      expect(server[:resolver_opts]).to eq(['allow-dup-ip'])
    end

    it 'accepts a resolvePrefer' do
      server[:resolve_prefer] = 'ipv6'
      expect(server[:resolve_prefer]).to eq('ipv6')
    end

    it 'accepts ssl' do
      server[:ssl] = false
      expect(server[:ssl]).to eq(:false)
    end

    it 'accepts sslVerify' do
      server[:ssl_verify] = false
      expect(server[:ssl_verify]).to eq(:false)
    end

    it 'accepts a sslCA' do
      server[:ssl_ca] = ['60cc45d3d7530']
      expect(server[:ssl_ca]).to eq(['60cc45d3d7530'])
    end

    it 'accepts a sslCRL' do
      server[:ssl_crl] = ['60cc45d3d7530']
      expect(server[:ssl_crl]).to eq(['60cc45d3d7530'])
    end

    it 'accepts a sslClientCertificate' do
      server[:ssl_client_certificate] = '610d3779926d6'
      expect(server[:ssl_client_certificate]).to eq('610d3779926d6')
    end

    it 'accepts a weight' do
      server[:weight] = '15'
      expect(server[:weight]).to eq('15')
    end

    it 'accepts a checkInterval' do
      server[:check_interval] = '150'
      expect(server[:check_interval]).to eq('150')
    end

    it 'accepts a checkDownInterval' do
      server[:check_down_interval] = '200'
      expect(server[:check_down_interval]).to eq('200')
    end

    it 'accepts a source' do
      server[:source] = '192.168.1.1'
      expect(server[:source]).to eq('192.168.1.1')
    end

    it 'accepts a advanced' do
      server[:advanced] = ''
      expect(server[:advanced]).to eq('')
    end
  end
end
