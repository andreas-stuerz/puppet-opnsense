# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsensePlugin')
require 'puppet/provider/opnsense_plugin/opnsense_plugin'

RSpec.describe Puppet::Provider::OpnsensePlugin::OpnsensePlugin do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }

  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }
  let(:plugins_device_1) do
    [
      {
        "name": 'os-acme-client',
          "version": '2.5',
          "comment": "Let's Encrypt client",
          "flatsize": '578KiB',
          "locked": 'N/A',
          "automatic": 'N/A',
          "license": 'BSD2CLAUSE',
          "repository": 'OPNsense',
          "origin": 'opnsense/os-acme-client',
          "provided": '1',
          "installed": '0',
          "path": 'OPNsense/opnsense/os-acme-client',
          "configured": '0'
      },
    ]
  end
  let(:plugins_device_2) do
    [
      {
        "name": 'os-clamav',
          "version": '1.7_1',
          "comment": 'Antivirus engine for detecting malicious threats',
          "flatsize": '47.5KiB',
          "locked": 'N/A',
          "automatic": 'N/A',
          "license": 'BSD2CLAUSE',
          "repository": 'OPNsense',
          "origin": 'opnsense/os-clamav',
          "provided": '1',
          "installed": '0',
          "path": 'OPNsense/opnsense/os-clamav',
          "configured": '0'
      },
    ]
  end

  describe 'get' do
    context 'with empty filter' do
      it 'returns all resources' do
        expect(Dir).to receive(:glob).and_return(devices)
        expect(Puppet::Util::Execution).to receive(:execute).with(
            [
              'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense1.example.com-config.yaml'),
              ['plugin', 'installed', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true },
          ).and_return(plugins_device_1.to_json)

        expect(Puppet::Util::Execution).to receive(:execute).with(
            [
              'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense2.example.com-config.yaml'),
              ['plugin', 'installed', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true },
          ).and_return(plugins_device_2.to_json)

        expect(provider.get(context, [])).to eq [
          {
            title: 'os-acme-client@opnsense1.example.com',
            name: 'os-acme-client',
            device: 'opnsense1.example.com',
            ensure: 'present',
          },
          {
            title: 'os-clamav@opnsense2.example.com',
            name: 'os-clamav',
            device: 'opnsense2.example.com',
            ensure: 'present',
          },
        ]
      end
    end

    context 'with filter name: os-acme-client, device: opnsense.example.com' do
      it 'returns resource os-virtualbox@opnsense.example.com' do
        expect(Puppet::Util::Execution).to receive(:execute).and_return(plugins_device_2.to_json)

        expect(provider.get(context, [{ name: 'os-acme-client', device: 'opnsense.example.com' }])).to eq [
          {
            title: 'os-clamav@opnsense.example.com',
              name: 'os-clamav',
              device: 'opnsense.example.com',
              ensure: 'present',
          },
        ]
      end
    end
  end

  describe 'create' do
    it 'creates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return({ "status": 'ok', "msg_uuid": '2a7ec303-febb-45c3-9dca-3dd820578710' })
      provider.create(context, 'os-nginx@opnsense.example.com',
                      name: 'os-nginx',
                      device: 'opnsense.example.com',
                      ensure: 'present')
    end
  end

  describe 'update' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return({ "status": 'ok', "msg_uuid": '2a7ec303-febb-45c3-9dca-3dd820578710' })
      provider.update(context, 'os-nginx@opnsense.example.com',
                      name: 'os-nginx',
                      device: 'opnsense2.example.com',
                      ensure: 'present')
    end
  end

  describe 'delete' do
    it 'deletes the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return({ "status": 'ok', "msg_uuid": '97ed1f9b-a18e-449a-9935-509c44fcd9fd' })
      provider.delete(context,
                      name: 'os-nginx',
                      device: 'opnsense.example.com')
    end
  end
end
