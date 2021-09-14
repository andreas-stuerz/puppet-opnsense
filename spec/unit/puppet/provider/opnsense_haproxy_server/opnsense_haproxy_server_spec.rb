# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsenseHaproxyServer')
require 'puppet/provider/opnsense_haproxy_server/opnsense_haproxy_server'

RSpec.describe Puppet::Provider::OpnsenseHaproxyServer::OpnsenseHaproxyServer do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }
  let(:server_device_1) do
    [
      {
        "id": '611285e4a471d2.77596072',
          "enabled": '1',
          "name": 'my_new_testserver',
          "description": 'test',
          "address": '10.0.0.1',
          "port": '9091',
          "checkport": '',
          "mode": 'active',
          "type": 'static',
          "serviceName": 'service_1',
          "number": '1',
          "linkedResolver": 'cea8f031-9aba-4f6e-86c2-f5f5f27a10b8',
          "resolverOpts": 'allow-dup-ip,ignore-weight',
          "resolvePrefer": '',
          "ssl": '1',
          "sslVerify": '1',
          "sslCA": '',
          "sslCRL": '',
          "sslClientCertificate": '',
          "weight": '10',
          "checkInterval": '10',
          "checkDownInterval": '',
          "source": '',
          "advanced": '',
          "uuid": '15e47988-d6fd-498f-9583-cd13a37408bd',
          "Resolver": 'my_resolver'
      },
    ]
  end
  let(:server_device_2) do
    [
      {
        "id": '6139b4a413dbc6.60034160',
          "enabled": '1',
          "name": 'testerver',
          "description": '',
          "address": '',
          "port": '',
          "checkport": '',
          "mode": 'active',
          "type": 'static',
          "serviceName": '',
          "number": '',
          "linkedResolver": '',
          "resolverOpts": '',
          "resolvePrefer": '',
          "ssl": '1',
          "sslVerify": '1',
          "sslCA": '',
          "sslCRL": '',
          "sslClientCertificate": '',
          "weight": '',
          "checkInterval": '',
          "checkDownInterval": '',
          "source": '',
          "advanced": '',
          "uuid": '20c33893-8c65-41dd-8951-5792abe249a0',
          "Resolver": ''
      },
      {
        "id": '6139c6a3ea7417.18216234',
          "enabled": '1',
          "name": 'testerver2',
          "description": '',
          "address": '',
          "port": '',
          "checkport": '',
          "mode": 'active',
          "type": 'static',
          "serviceName": '',
          "number": '',
          "linkedResolver": '',
          "resolverOpts": '',
          "resolvePrefer": '',
          "ssl": '0',
          "sslVerify": '0',
          "sslCA": '',
          "sslCRL": '',
          "sslClientCertificate": '',
          "weight": '',
          "checkInterval": '',
          "checkDownInterval": '',
          "source": '',
          "advanced": '',
          "uuid": 'ceb75158-7d69-42a9-bded-5bb3080be199',
          "Resolver": ''
      },
    ]
  end

  describe '#get' do
    it 'processes resources' do
      expect(Dir).to receive(:glob).and_return(devices)
      expect(Puppet::Util::Execution).to receive(:execute).with(
          [
            'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense1.example.com-config.yaml'),
            ['haproxy', 'server', 'list', '-o', 'json']
          ],
          { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
        ).and_return(server_device_1.to_json)
      expect(Puppet::Util::Execution).to receive(:execute).with(
          [
            'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense2.example.com-config.yaml'),
            ['haproxy', 'server', 'list', '-o', 'json']
          ],
          { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
        ).and_return(server_device_2.to_json)

      expect(provider.get(context, [])).to eq [
        {
          title: 'my_new_testserver@opnsense1.example.com',
            name: 'my_new_testserver',
            device: 'opnsense1.example.com',
            uuid: '15e47988-d6fd-498f-9583-cd13a37408bd',
            enabled: true,
            description: 'test',
            address: '10.0.0.1',
            port: '9091',
            checkport: '',
            mode: 'active',
            type: 'static',
            service_name: 'service_1',
            linked_resolver: 'cea8f031-9aba-4f6e-86c2-f5f5f27a10b8',
            resolver_opts: ['allow-dup-ip', 'ignore-weight'],
            resolve_prefer: '',
            ssl: true,
            ssl_verify: true,
            ssl_ca: [],
            ssl_crl: [],
            ssl_client_certificate: '',
            weight: '10',
            check_interval: '10',
            check_down_interval: '',
            source: '',
            advanced: '',
            ensure: 'present',
        },
        {
          title: 'testerver@opnsense2.example.com',
            name: 'testerver',
            device: 'opnsense2.example.com',
            uuid: '20c33893-8c65-41dd-8951-5792abe249a0',
            enabled: true,
            description: '',
            address: '',
            port: '',
            checkport: '',
            mode: 'active',
            type: 'static',
            service_name: '',
            linked_resolver: '',
            resolver_opts: [],
            resolve_prefer: '',
            ssl: true,
            ssl_verify: true,
            ssl_ca: [],
            ssl_crl: [],
            ssl_client_certificate: '',
            weight: '',
            check_interval: '',
            check_down_interval: '',
            source: '',
            advanced: '',
            ensure: 'present',
        },
        {
          title: 'testerver2@opnsense2.example.com',
            name: 'testerver2',
            device: 'opnsense2.example.com',
            uuid: 'ceb75158-7d69-42a9-bded-5bb3080be199',
            enabled: true,
            description: '',
            address: '',
            port: '',
            checkport: '',
            mode: 'active',
            type: 'static',
            service_name: '',
            linked_resolver: '',
            resolver_opts: [],
            resolve_prefer: '',
            ssl: false,
            ssl_verify: false,
            ssl_ca: [],
            ssl_crl: [],
            ssl_client_certificate: '',
            weight: '',
            check_interval: '',
            check_down_interval: '',
            source: '',
            advanced: '',
            ensure: 'present',
        },
      ]
    end
  end

  describe 'create webserver1@opnsense2.example.com' do
    it 'creates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved", "uuid": "1a2d6a8e-ed7a-4377-b723-e1582b2b2c18"}')

      provider.create(context, 'webserver1@opnsense2.example.com',
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
                      ensure: 'present')
    end
  end

  describe 'update webserver1@opnsense2.example.com' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved"}')
      server_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = server_device_2

      provider.update(context, { name: 'webserver1', device: 'opnsense2.example.com' },
                      enabled: false,
                      description: 'modified primary webserver',
                      address: 'webserver1.example.de',
                      port: '80',
                      checkport: '443',
                      mode: 'backup',
                      type: 'static',
                      service_name: '',
                      linked_resolver: '',
                      resolver_opts: ['allow-dup-ip'],
                      resolve_prefer: 'ipv4',
                      ssl: false,
                      ssl_verify: false,
                      ssl_ca: [],
                      ssl_crl: [],
                      ssl_client_certificate: '60cc4641eb577',
                      weight: '20',
                      check_interval: '150',
                      check_down_interval: '250',
                      source: '10.0.0.2',
                      advanced: '',
                      ensure: 'present')
    end
  end

  describe 'delete webserver1@opnsense2.example.com' do
    it 'deletes the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return('{"result": "deleted"}')
      server_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = server_device_2

      provider.delete(context, { name: 'webserver1', device: 'opnsense2.example.com' })
    end
  end
end
