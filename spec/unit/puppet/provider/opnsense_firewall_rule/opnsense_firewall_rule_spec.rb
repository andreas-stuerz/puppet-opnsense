# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsenseFirewallRule')
require 'puppet/provider/opnsense_firewall_rule/opnsense_firewall_rule'

RSpec.describe Puppet::Provider::OpnsenseFirewallRule::OpnsenseFirewallRule do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }
  let(:rules_device_1) do
    [
      {
        "enabled": '1',
          "sequence": '1',
          "action": 'pass',
          "quick": '1',
          "interface": 'lan,wan',
          "direction": 'in',
          "ipprotocol": 'inet',
          "protocol": 'TCP',
          "source_net": 'any',
          "source_not": '0',
          "source_port": '',
          "destination_net": 'any',
          "destination_not": '0',
          "destination_port": '',
          "gateway": '',
          "log": '0',
          "description": 'example rule1',
          "uuid": '624cb3ca-3b76-4177-b736-4381c6525f37'
      },
      {
        "enabled": '1',
          "sequence": '2',
          "action": 'block',
          "quick": '1',
          "interface": 'lan',
          "direction": 'in',
          "ipprotocol": 'inet',
          "protocol": 'TCP',
          "source_net": '192.168.61.1',
          "source_not": '0',
          "source_port": '',
          "destination_net": '192.168.70.0/24',
          "destination_not": '0',
          "destination_port": 'https',
          "gateway": '',
          "log": '0',
          "description": 'example rule 2',
          "uuid": '002db5b7-791e-4e2f-8625-4350ee5ae8ac'
      },
    ]
  end

  let(:rules_device_2) do
    [
      {
        "enabled": '1',
          "sequence": '1',
          "action": 'block',
          "quick": '1',
          "interface": 'lan',
          "direction": 'in',
          "ipprotocol": 'inet',
          "protocol": 'TCP',
          "source_net": '10.0.50.0/24',
          "source_not": '0',
          "source_port": '',
          "destination_net": 'any',
          "destination_not": '0',
          "destination_port": 'https',
          "gateway": '',
          "log": '0',
          "description": 'example rule1',
          "uuid": '731cb3ca-3b76-4177-b736-4381c6525f45'
      },
    ]
  end

  describe '#get' do
    context 'with empty filter' do
      it 'returns all resources' do
        expect(Dir).to receive(:glob).and_return(devices)
        expect(Puppet::Util::Execution).to receive(:execute).with(
            [
              'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense1.example.com-config.yaml'),
              ['firewall', 'rule', 'list', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true },
          ).and_return(rules_device_1.to_json)
        expect(Puppet::Util::Execution).to receive(:execute).with(
            [
              'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense2.example.com-config.yaml'),
              ['firewall', 'rule', 'list', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true },
          ).and_return(rules_device_2.to_json)

        expect(provider.get(context, [])).to eq [
          {
            title: 'example rule1@opnsense1.example.com',
              sequence: '1',
              description: 'example rule1',
              device: 'opnsense1.example.com',
              uuid: '624cb3ca-3b76-4177-b736-4381c6525f37',
              action: 'pass',
              interface: ['lan', 'wan'],
              direction: 'in',
              quick: true,
              ipprotocol: 'inet',
              protocol: 'TCP',
              source_net: 'any',
              source_port: '',
              source_not: false,
              destination_net: 'any',
              destination_port: '',
              destination_not: false,
              gateway: '',
              log: false,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'example rule 2@opnsense1.example.com',
              sequence: '2',
              description: 'example rule 2',
              device: 'opnsense1.example.com',
              uuid: '002db5b7-791e-4e2f-8625-4350ee5ae8ac',
              action: 'block',
              interface: ['lan'],
              direction: 'in',
              quick: true,
              ipprotocol: 'inet',
              protocol: 'TCP',
              source_net: '192.168.61.1',
              source_port: '',
              source_not: false,
              destination_net: '192.168.70.0/24',
              destination_port: 'https',
              destination_not: false,
              gateway: '',
              log: false,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'example rule1@opnsense2.example.com',
              sequence: '1',
              description: 'example rule1',
              device: 'opnsense2.example.com',
              uuid: '731cb3ca-3b76-4177-b736-4381c6525f45',
              action: 'block',
              interface: ['lan'],
              direction: 'in',
              quick: true,
              ipprotocol: 'inet',
              protocol: 'TCP',
              source_net: '10.0.50.0/24',
              source_port: '',
              source_not: false,
              destination_net: 'any',
              destination_port: 'https',
              destination_not: false,
              gateway: '',
              log: false,
              enabled: true,
              ensure: 'present'
          },
        ]
      end
    end

    context 'with filter device: opnsense2.example.com' do
      it 'returns all resources for opnsense2.example.com' do
        expect(Puppet::Util::Execution).to receive(:execute).and_return(rules_device_2.to_json)
        expect(provider.get(context, [{ device: 'opnsense2.example.com' }])).to eq [
          {
            title: 'example rule1@opnsense2.example.com',
            sequence: '1',
            description: 'example rule1',
            device: 'opnsense2.example.com',
            uuid: '731cb3ca-3b76-4177-b736-4381c6525f45',
            action: 'block',
            interface: ['lan'],
            direction: 'in',
            quick: true,
            ipprotocol: 'inet',
            protocol: 'TCP',
            source_net: '10.0.50.0/24',
            source_port: '',
            source_not: false,
            destination_net: 'any',
            destination_port: 'https',
            destination_not: false,
            gateway: '',
            log: false,
            enabled: true,
            ensure: 'present'
          },
        ]
      end
    end
  end

  describe 'create example rule1@opnsense2.example.com' do
    it 'creates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved", "uuid": "1a2d6a8e-ed7a-4377-b723-e1582b2b2c18"}')

      provider.create(context, 'another_rule@opnsense2.example.com',
                      sequence: '1',
                      device: 'opnsense2.example.com',
                      action: 'pass',
                      interface: ['lan'],
                      direction: 'in',
                      quick: true,
                      ipprotocol: 'inet',
                      protocol: 'TCP',
                      source_net: 'any',
                      source_port: '',
                      source_not: false,
                      destination_net: 'any',
                      destination_port: 'ssh',
                      destination_not: false,
                      gateway: '',
                      log: false,
                      enabled: true,
                      ensure: 'present')
    end
  end

  describe 'update example rule1@opnsense2.example.com' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved"}')
      rules_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = rules_device_2

      provider.update(context, { description: 'example rule1', device: 'opnsense2.example.com' },
                      sequence: '2',
                      device: 'opnsense2.example.com',
                      action: 'block',
                      interface: ['lan', 'wan'],
                      direction: 'out',
                      quick: false,
                      ipprotocol: 'inet',
                      protocol: 'UDP',
                      source_net: 'any',
                      source_port: '',
                      source_not: true,
                      destination_net: 'any',
                      destination_port: '',
                      destination_not: true,
                      gateway: '',
                      log: true,
                      enabled: false,
                      ensure: 'present')
    end
  end

  describe 'delete example rule1@opnsense2.example.com' do
    it 'deletes the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return('{"result": "deleted"}')
      rules_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = rules_device_2

      provider.delete(context, { description: 'example rule1', device: 'opnsense2.example.com' })
    end
  end

  describe 'delete non existent rule' do
    it 'throws puppet error' do
      rules_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = rules_device_2

      expect { provider.delete(context, { description: 'non existent rule', device: 'opnsense2.example.com' }) }
        .to raise_error(Puppet::ResourceError)
    end
  end
end
