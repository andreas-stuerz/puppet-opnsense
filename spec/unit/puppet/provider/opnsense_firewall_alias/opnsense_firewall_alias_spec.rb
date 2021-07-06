# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsenseFirewallAlias')
require 'puppet/provider/opnsense_firewall_alias/opnsense_firewall_alias'

RSpec.describe Puppet::Provider::OpnsenseFirewallAlias::OpnsenseFirewallAlias do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }

  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }
  let(:aliases_device_1) do
    [
      {
        "enabled": '1',
          "name": 'hosts_alias',
          "type": 'host',
          "proto": '',
          "counters": '1',
          "updatefreq": '',
          "content": '10.0.0.1,!10.0.0.5',
          "description": 'Some hosts',
          "uuid": 'b6ae4857-8414-4440-acce-c09e4ae899fa'
      },
      {
        "enabled": '1',
          "name": 'network_alias',
          "type": 'network',
          "proto": '',
          "counters": '1',
          "updatefreq": '',
          "content": '192.168.1.0/24,!192.168.1.128/25',
          "description": 'Some networks',
          "uuid": 'a6ae4857-8414-5550-acce-c09e4ae899fa'
      },
      {
        "enabled": '1',
          "name": 'ports_alias',
          "type": 'port',
          "proto": '',
          "counters": '',
          "updatefreq": '',
          "content": '80,443',
          "description": 'Some ports',
          "uuid": 'd6ae1257-8414-4440-acce-c09e4ae899fb'
      },
      {
        "enabled": '0',
          "name": 'url_alias',
          "type": 'url',
          "proto": '',
          "counters": '1',
          "updatefreq": '',
          "content": 'https://www.spamhaus.org/drop/drop.txt,https://www.spamhaus.org/drop/edrop.txt',
          "description": 'spamhaus fetched once.',
          "uuid": 'b6ae4857-8414-4440-acce-c09e4ae899fd'
      },
      {
        "enabled": '1',
          "name": 'url_table_alias',
          "type": 'urltable',
          "proto": 'IPv4,IPv6',
          "counters": '0',
          "updatefreq": '0.5',
          "content": 'https://www.spamhaus.org/drop/drop.txt,https://www.spamhaus.org/drop/edrop.txt',
          "description": 'Spamhaus block list',
          "uuid": 'ad51e4ea-ee3f-49dc-a662-1f8f88b5f18a'
      },
      {
        "enabled": '1',
          "name": 'geoip_alias',
          "type": 'geoip',
          "proto": 'IPv4,IPv6',
          "counters": '1',
          "updatefreq": '',
          "content": 'DE,GR',
          "description": 'Only german and greek',
          "uuid": '5d385340-5d56-432d-8bd1-77267c122ede'
      },
      {
        "enabled": '1',
          "name": 'networkgroup_alias',
          "type": 'networkgroup',
          "proto": '',
          "counters": '0',
          "updatefreq": '',
          "content": 'hosts_alias,network_alias',
          "description": 'Combine different network aliases into one',
          "uuid": 'bd51e4ea-ee3f-49dc-a662-1f8f88b5f11f'
      },
      {
        "enabled": '1',
          "name": 'mac_alias',
          "type": 'mac',
          "proto": '',
          "counters": '0',
          "updatefreq": '',
          "content": 'f4:90:ea,0c:4d:e9:b1:05:f0',
          "description": 'MAC address or partial mac addresses',
          "uuid": 'cd41e4ea-ee3f-49dc-a662-1f8f88b5f22a'
      },
      {
        "enabled": '1',
          "name": 'external_alias',
          "type": 'external',
          "proto": 'IPv4',
          "counters": '1',
          "updatefreq": '',
          "content": '',
          "description": 'Externally managed',
          "uuid": 'dd22e4ea-ee3f-49dc-a662-1f8f88b5f33b'
      },
    ]
  end
  let(:aliases_device_2) do
    [
      {
        "enabled": '1',
          "name": 'bogons',
          "type": 'external',
          "proto": '',
          "counters": '',
          "updatefreq": '',
          "content": '',
          "description": 'bogon networks (internal)',
          "uuid": 'bogons'
      },
      {
        "enabled": '1',
          "name": 'bogonsv6',
          "type": 'external',
          "proto": '',
          "counters": '',
          "updatefreq": '',
          "content": '',
          "description": 'bogon networks IPv6 (internal)',
          "uuid": 'bogonsv6'
      },
      {
        "enabled": '1',
          "name": 'sshlockout',
          "type": 'external',
          "proto": '',
          "counters": '',
          "updatefreq": '',
          "content": '',
          "description": 'abuse lockout table (internal)',
          "uuid": 'sshlockout'
      },
      {
        "enabled": '1',
          "name": 'virusprot',
          "type": 'external',
          "proto": '',
          "counters": '',
          "updatefreq": '',
          "content": '',
          "description": 'overload table for rate limitting (internal)',
          "uuid": 'virusprot'
      },
    ]
  end

  describe '#get' do
    context 'with empty filter' do
      it 'returns all resources' do
        expect(Dir).to receive(:glob).and_return(devices)
        expect(Puppet::Util::Execution).to receive(:execute).with(
            [
              'opn-cli', '-c', '/Users/as/.puppet-opnsense/opnsense1.example.com-config.yaml',
              ['firewall', 'alias', 'list', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true },
          ).and_return(aliases_device_1.to_json)

        expect(Puppet::Util::Execution).to receive(:execute).with(
            [
              'opn-cli', '-c', '/Users/as/.puppet-opnsense/opnsense2.example.com-config.yaml',
              ['firewall', 'alias', 'list', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true },
          ).and_return(aliases_device_2.to_json)

        expect(provider.get(context, [])).to eq [
          {
            title: 'hosts_alias@opnsense1.example.com',
              name: 'hosts_alias',
              device: 'opnsense1.example.com',
              type: 'host',
              description: 'Some hosts',
              content: ['10.0.0.1', '!10.0.0.5'],
              proto: '',
              updatefreq: '',
              counters: true,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'network_alias@opnsense1.example.com',
              name: 'network_alias',
              device: 'opnsense1.example.com',
              type: 'network',
              description: 'Some networks',
              content: ['192.168.1.0/24', '!192.168.1.128/25'],
              proto: '',
              updatefreq: '',
              counters: true,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'ports_alias@opnsense1.example.com',
              name: 'ports_alias',
              device: 'opnsense1.example.com',
              type: 'port',
              description: 'Some ports',
              content: ['80', '443'],
              proto: '',
              updatefreq: '',
              counters: '',
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'url_alias@opnsense1.example.com',
              name: 'url_alias',
              device: 'opnsense1.example.com',
              type: 'url',
              description: 'spamhaus fetched once.',
              content: ['https://www.spamhaus.org/drop/drop.txt', 'https://www.spamhaus.org/drop/edrop.txt'],
              proto: '',
              updatefreq: '',
              counters: true,
              enabled: false,
              ensure: 'present'
          },
          {
            title: 'url_table_alias@opnsense1.example.com',
              name: 'url_table_alias',
              device: 'opnsense1.example.com',
              type: 'urltable',
              description: 'Spamhaus block list',
              content:  ['https://www.spamhaus.org/drop/drop.txt', 'https://www.spamhaus.org/drop/edrop.txt'],
              proto: 'IPv4,IPv6',
              updatefreq: 0.5,
              counters: false,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'geoip_alias@opnsense1.example.com',
              name: 'geoip_alias',
              device: 'opnsense1.example.com',
              type: 'geoip',
              description: 'Only german and greek',
              content: ['DE', 'GR'],
              proto: 'IPv4,IPv6',
              updatefreq: '',
              counters: true,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'networkgroup_alias@opnsense1.example.com',
              name: 'networkgroup_alias',
              device: 'opnsense1.example.com',
              type: 'networkgroup',
              description: 'Combine different network aliases into one',
              content: ['hosts_alias', 'network_alias'],
              proto: '',
              updatefreq: '',
              counters: false,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'mac_alias@opnsense1.example.com',
              name: 'mac_alias',
              device: 'opnsense1.example.com',
              type: 'mac',
              description: 'MAC address or partial mac addresses',
              content: ['f4:90:ea', '0c:4d:e9:b1:05:f0'],
              proto: '',
              updatefreq: '',
              counters: false,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'external_alias@opnsense1.example.com',
              name: 'external_alias',
              device: 'opnsense1.example.com',
              type: 'external',
              description: 'Externally managed',
              content: [],
              proto: 'IPv4',
              updatefreq: '',
              counters: true,
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'bogons@opnsense2.example.com',
              name: 'bogons',
              device: 'opnsense2.example.com',
              type: 'external',
              description: 'bogon networks (internal)',
              content: [],
              proto: '',
              updatefreq: '',
              counters: '',
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'bogonsv6@opnsense2.example.com',
              name: 'bogonsv6',
              device: 'opnsense2.example.com',
              type: 'external',
              description: 'bogon networks IPv6 (internal)',
              content: [],
              proto: '',
              updatefreq: '',
              counters: '',
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'sshlockout@opnsense2.example.com',
              name: 'sshlockout',
              device: 'opnsense2.example.com',
              type: 'external',
              description: 'abuse lockout table (internal)',
              content: [],
              proto: '',
              updatefreq: '',
              counters: '',
              enabled: true,
              ensure: 'present'
          },
          {
            title: 'virusprot@opnsense2.example.com',
              name: 'virusprot',
              device: 'opnsense2.example.com',
              type: 'external',
              description: 'overload table for rate limitting (internal)',
              content: [],
              proto: '',
              updatefreq: '',
              counters: '',
              enabled: true,
              ensure: 'present'
          },
        ]
      end
    end

    context 'with filter device: opnsense2.example.com' do
      it 'returns all resources for opnsense2.example.com' do
        expect(Puppet::Util::Execution).to receive(:execute).and_return(aliases_device_2.to_json)

        expect(provider.get(context, [{ device: 'opnsense2.example.com' }])).to eq [
          {
            title: 'bogons@opnsense2.example.com',
             name: 'bogons',
             device: 'opnsense2.example.com',
             type: 'external',
             description: 'bogon networks (internal)',
             content: [],
             proto: '',
             updatefreq: '',
             counters: '',
             enabled: true,
             ensure: 'present'
          },
          {
            title: 'bogonsv6@opnsense2.example.com',
             name: 'bogonsv6',
             device: 'opnsense2.example.com',
             type: 'external',
             description: 'bogon networks IPv6 (internal)',
             content: [],
             proto: '',
             updatefreq: '',
             counters: '',
             enabled: true,
             ensure: 'present'
          },
          {
            title: 'sshlockout@opnsense2.example.com',
             name: 'sshlockout',
             device: 'opnsense2.example.com',
             type: 'external',
             description: 'abuse lockout table (internal)',
             content: [],
             proto: '',
             updatefreq: '',
             counters: '',
             enabled: true,
             ensure: 'present'
          },
          {
            title: 'virusprot@opnsense2.example.com',
             name: 'virusprot',
             device: 'opnsense2.example.com',
             type: 'external',
             description: 'overload table for rate limitting (internal)',
             content: [],
             proto: '',
             updatefreq: '',
             counters: '',
             enabled: true,
             ensure: 'present'
          },
        ]
      end
    end
  end

  describe 'create(context, name, should)' do
    it 'creates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return("saved \n")
      provider.create(context, 'geoip_alias@opnsense2.example.com',
                      name: 'geoip_alias',
                      device: 'opnsense2.example.com',
                      type: 'geoip',
                      description: 'Only german and greek',
                      content: ['DE', 'GR'],
                      proto: 'IPv4,IPv6',
                      updatefreq: '',
                      counters: true,
                      enabled: true,
                      ensure: 'present')
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return("saved \n")

      provider.update(context, 'geoip_alias@opnsense2.example.com',
                      name: 'geoip_alias',
                      device: 'opnsense1.example.com',
                      type: 'geoip',
                      description: 'Only german',
                      content: [],
                      proto: 'IPv4',
                      updatefreq: '',
                      counters: false,
                      enabled: false,
                      ensure: 'present')
    end
  end

  describe 'delete(context, name)' do
    it 'deletes the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return("deleted \n")

      provider.delete(context,
                      name: 'geoip_alias',
                      device: 'opnsense1.example.com')
    end
  end
end
