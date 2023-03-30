# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsenseSyslogDestination')
require 'puppet/provider/opnsense_syslog_destination/opnsense_syslog_destination'

RSpec.describe Puppet::Provider::OpnsenseSyslogDestination::OpnsenseSyslogDestination do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }
  let(:syslog_destination_device_1) do
    [
      {
        "enabled": '1',
        "transport": 'tcp4',
        "program": 'ntp',
        "level": 'info,notice,warn,err,crit,alert,emerg',
        "facility": 'ntp,security,console',
        "hostname": '10.0.0.1',
        "certificate": '',
        "port": '514',
        "rfc5424": '1',
        "description": 'example syslog_destination 1',
        "uuid": '624cb3ca-3b76-4177-b736-4381c6525f37'
      },
      {
        "enabled": '1',
        "transport": 'tls4',
        "program": '',
        "level": 'crit,alert,emerg',
        "facility": '',
        "hostname": '10.0.0.2',
        "certificate": '60cc4641eb577',
        "port": '514',
        "rfc5424": '1',
        "description": 'example syslog_destination 2',
        "uuid": '002db5b7-791e-4e2f-8625-4350ee5ae8ac'
      },
    ]
  end

  let(:syslog_destination_device_2) do
    [
      {
        "enabled": '1',
        "transport": 'udp4',
        "program": '',
        "level": '',
        "facility": '',
        "hostname": '10.0.0.3',
        "certificate": '',
        "port": '514',
        "rfc5424": '0',
        "description": 'example syslog_destination 3',
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
              ['syslog', 'destination', 'list', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
          ).and_return(syslog_destination_device_1.to_json)
        expect(Puppet::Util::Execution).to receive(:execute).with(
            [
              'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense2.example.com-config.yaml'),
              ['syslog', 'destination', 'list', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
          ).and_return(syslog_destination_device_2.to_json)

        expect(provider.get(context, [])).to eq [
          {
            title: 'example syslog_destination 1@opnsense1.example.com',
              device: 'opnsense1.example.com',
              enabled: true,
              transport: 'tcp4',
              program: 'ntp',
              level: ['info', 'notice', 'warn', 'err', 'crit', 'alert', 'emerg'],
              facility: ['ntp', 'security', 'console'],
              hostname: '10.0.0.1',
              certificate: '',
              port: '514',
              rfc5424: true,
              description: 'example syslog_destination 1',
              uuid: '624cb3ca-3b76-4177-b736-4381c6525f37',
              ensure: 'present'
          },
          {
            title: 'example syslog_destination 2@opnsense1.example.com',
              device: 'opnsense1.example.com',
              enabled: true,
              transport: 'tls4',
              program: '',
              level: ['crit', 'alert', 'emerg'],
              facility: [],
              hostname: '10.0.0.2',
              certificate: '60cc4641eb577',
              port: '514',
              rfc5424: true,
              description: 'example syslog_destination 2',
              uuid: '002db5b7-791e-4e2f-8625-4350ee5ae8ac',
              ensure: 'present'
          },
          {
            title: 'example syslog_destination 3@opnsense2.example.com',
              device: 'opnsense2.example.com',
              enabled: true,
              transport: 'udp4',
              program: '',
              level: [],
              facility: [],
              hostname: '10.0.0.3',
              certificate: '',
              port: '514',
              rfc5424: false,
              description: 'example syslog_destination 3',
              uuid: '731cb3ca-3b76-4177-b736-4381c6525f45',
              ensure: 'present'
          },
        ]
      end
    end

    context 'with filter device: opnsense2.example.com' do
      it 'returns all resources for opnsense2.example.com' do
        expect(Puppet::Util::Execution).to receive(:execute).and_return(syslog_destination_device_2.to_json)
        expect(provider.get(context, [{ device: 'opnsense2.example.com' }])).to eq [
          {
            title: 'example syslog_destination 3@opnsense2.example.com',
            device: 'opnsense2.example.com',
            enabled: true,
            transport: 'udp4',
            program: '',
            level: [],
            facility: [],
            hostname: '10.0.0.3',
            certificate: '',
            port: '514',
            rfc5424: false,
            description: 'example syslog_destination 3',
            uuid: '731cb3ca-3b76-4177-b736-4381c6525f45',
            ensure: 'present'
          },
        ]
      end
    end
  end

  describe 'create example another_syslog_destination@opnsense2.example.com' do
    it 'creates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved", "uuid": "1a2d6a8e-ed7a-4377-b723-e1582b2b2c18"}')

      provider.create(context, 'another_syslog_destination@opnsense2.example.com',
                      device: 'opnsense2.example.com',
                      enabled: true,
                      transport: 'tcp4',
                      program: '',
                      level: [],
                      facility: [],
                      hostname: '192.168.0.1',
                      certificate: '',
                      port: '514',
                      rfc5424: true,
                      ensure: 'present')
    end
  end

  describe 'update example example syslog_destination 3@opnsense2.example.com' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved"}')
      syslog_destination_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = syslog_destination_device_2

      provider.update(context, { description: 'example syslog_destination 3', device: 'opnsense2.example.com' },
                      device: 'opnsense2.example.com',
                      enabled: false,
                      transport: 'udp4',
                      program: 'ntp',
                      level: ['info'],
                      facility: ['ntp'],
                      hostname: '192.168.0.5',
                      certificate: '',
                      port: '1514',
                      rfc5424: false,
                      ensure: 'present')
    end
  end

  describe 'delete example example syslog_destination 3@opnsense2.example.com' do
    it 'deletes the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return('{"result": "deleted"}')
      syslog_destination_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = syslog_destination_device_2

      provider.delete(context, { description: 'example syslog_destination 3', device: 'opnsense2.example.com' })
    end
  end

  describe 'delete non existent syslog_destination' do
    it 'throws puppet error' do
      syslog_destination_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = syslog_destination_device_2

      expect { provider.delete(context, { description: 'non existent syslog_destination', device: 'opnsense2.example.com' }) }
        .to raise_error(Puppet::Error)
    end
  end
end
