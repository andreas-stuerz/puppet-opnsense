# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsenseNodeexporterConfig')
require 'puppet/provider/opnsense_nodeexporter_config/opnsense_nodeexporter_config'

RSpec.describe Puppet::Provider::OpnsenseNodeexporterConfig::OpnsenseNodeexporterConfig do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }

  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }

  let(:nodeexporter_config_device_1) do
      {
        "enabled": '0',
        "listenaddress": '0.0.0.0',
        "listenport": '9100',
        "cpu": '1',
        "exec": '1',
        "filesystem": '1',
        "loadavg": '1',
        "meminfo": '1',
        "netdev": '1',
        "time": '1',
        "devstat": '1',
        "interrupts": '0',
        "ntp": '0',
        "zfs": '0',
      }
  end
  let(:nodeexporter_config_device_2) do
    {
      "enabled": '1',
      "listenaddress": '10.0.0.1',
      "listenport": '9200',
      "cpu": '1',
      "exec": '0',
      "filesystem": '0',
      "loadavg": '0',
      "meminfo": '0',
      "netdev": '0',
      "time": '0',
      "devstat": '0',
      "interrupts": '0',
      "ntp": '0',
      "zfs": '0',
    }
  end

  describe 'get' do
    context 'with empty filter' do
      it 'returns all resources' do
        expect(Dir).to receive(:glob).and_return(devices)
        expect(Puppet::Util::Execution).to receive(:execute).with(
          [
            'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense1.example.com-config.yaml'),
            ['nodeexporter', 'config', 'show', '-o', 'json']
          ],
          { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
          ).and_return(nodeexporter_config_device_1.to_json)

        expect(Puppet::Util::Execution).to receive(:execute).with(
          [
            'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense2.example.com-config.yaml'),
            ['nodeexporter', 'config', 'show', '-o', 'json']
          ],
          { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
          ).and_return(nodeexporter_config_device_2.to_json)

        expect(provider.get(context, [])).to eq [
            {
              title: 'opnsense1.example.com',
              enabled: false,
              listen_address: '0.0.0.0',
              listen_port: '9100',
              cpu: true,
              exec: true,
              filesystem: true,
              loadavg: true,
              meminfo: true,
              netdev: true,
              time: true,
              devstat: true,
              interrupts: false,
              ntp: false,
              zfs: false,
              device: 'opnsense1.example.com',
              ensure: 'present',
            },
            {
              title: 'opnsense2.example.com',
              enabled: true,
              listen_address: '10.0.0.1',
              listen_port: '9200',
              cpu: true,
              exec: false,
              filesystem: false,
              loadavg: false,
              meminfo: false,
              netdev: false,
              time: false,
              devstat: false,
              interrupts: false,
              ntp: false,
              zfs: false,
              device: 'opnsense2.example.com',
              ensure: 'present',
            },
        ]
      end
    end
  end

  describe 'create(context, name, should)' do
    it 'also updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
                                           .and_return('{"result": "saved"}')

      provider.create(context, 'opnsense1.example.com',
                      title: 'opnsense1.example.com',
                      enabled: false,
                      listen_address: '192.168.0.5',
                      listen_port: '9501',
                      cpu: true,
                      exec: true,
                      filesystem: true,
                      loadavg: true,
                      meminfo: true,
                      netdev: true,
                      time: true,
                      devstat: true,
                      interrupts: true,
                      ntp: true,
                      zfs: true,
                      device: 'opnsense1.example.com',
                      ensure: 'present',
                      )
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved"}')

      provider.update(context, 'opnsense1.example.com',
                      title: 'opnsense1.example.com',
                      enabled: true,
                      listen_address: '192.168.0.1',
                      listen_port: '9500',
                      cpu: false,
                      exec: false,
                      filesystem: false,
                      loadavg: false,
                      meminfo: false,
                      netdev: false,
                      time: false,
                      devstat: false,
                      interrupts: false,
                      ntp: false,
                      zfs: false,
                      device: 'opnsense1.example.com',
                      ensure: 'present',
      )
    end
  end

  describe 'delete opnsense2.example.com' do
    it 'is not implemented' do
      expect {
        provider.delete(context, 'opnsense2.example.com')
      }.to raise_error(NotImplementedError, %r{not implemented})
    end
  end
end
