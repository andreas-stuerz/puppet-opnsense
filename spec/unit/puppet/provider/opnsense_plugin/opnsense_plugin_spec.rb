# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsensePlugin')
require 'puppet/provider/opnsense_plugin/opnsense_plugin'

RSpec.describe Puppet::Provider::OpnsensePlugin::OpnsensePlugin do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }

  let(:devices) { ['opnsense.example.com', 'opnsense2.example.com'] }
  let(:plugins_device_1) { ['os-acme-client'] }
  let(:plugins_device_2) { ['os-clamav'] }

  describe 'get' do
    context 'with empty filter' do
      it 'returns all resources' do
        expect(Dir).to receive(:glob).and_return(devices)
        expect(Puppet::Util::Execution).to receive(:execute).and_return("os-acme-client\n").twice

        expect(provider.get(context, [])).to eq [
          {
            title: 'os-acme-client@opnsense.example.com',
            name: 'os-acme-client',
            device: 'opnsense.example.com',
            ensure: 'present',
          },
          {
            title: 'os-acme-client@opnsense2.example.com',
            name: 'os-acme-client',
            device: 'opnsense2.example.com',
            ensure: 'present',
          },
        ]
      end
    end

    context 'with filter name: os-acme-client, device: opnsense.example.com' do
      it 'returns resource os-virtualbox@opnsense.example.com' do
        expect(Puppet::Util::Execution).to receive(:execute).and_return("os-acme-client\n")

        expect(provider.get(context, [{ name: 'os-acme-client', device: 'opnsense.example.com' }])).to eq [
          {
            title: 'os-acme-client@opnsense.example.com',
              name: 'os-acme-client',
              device: 'opnsense.example.com',
              ensure: 'present',
          },
        ]
      end
    end
  end

  describe 'create' do
    it 'creates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return("ok\n")
      provider.create(context, 'os-nginx@opnsense.example.com',
                      name: 'os-nginx',
                      device: 'opnsense.example.com',
                      ensure: 'present')
    end
  end

  describe 'update' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return("ok\n")
      provider.update(context, 'os-nginx@opnsense.example.com',
                      name: 'os-nginx',
                      device: 'opnsense2.example.com',
                      ensure: 'present')
    end
  end

  describe 'delete' do
    it 'deletes the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return("ok\n")
      provider.delete(context,
                      name: 'os-nginx',
                      device: 'opnsense.example.com')
    end
  end
end
