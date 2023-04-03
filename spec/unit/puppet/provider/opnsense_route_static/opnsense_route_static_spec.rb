# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsenseRouteStatic')
require 'puppet/provider/opnsense_route_static/opnsense_route_static'

RSpec.describe Puppet::Provider::OpnsenseRouteStatic::OpnsenseRouteStatic do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }
  let(:route_static_device_1) do
    [
      {
        "network": '10.0.0.98/24',
        "gateway": 'WAN_DHCP',
        "descr": 'example route_static 1',
        "disabled": '1',
        
        "uuid": '624cb3ca-3b76-4177-b736-4381c6525f37'
      },
      {
        "network": '192.168.1.0/24',
        "gateway": 'NULL4',
        "descr": 'example route_static 2',
        "disabled": '1',
        "uuid": '002db5b7-791e-4e2f-8625-4350ee5ae8ac'
      },
    ]
  end

  let(:route_static_device_2) do
    [
      {
        "network": '10.0.4.0/24',
        "gateway": 'NULL4',
        "descr": 'example route_static 1',
        "disabled": '1',
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
              ['route', 'static', 'list', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
          ).and_return(route_static_device_1.to_json)
        expect(Puppet::Util::Execution).to receive(:execute).with(
            [
              'opn-cli', '-c', File.expand_path('~/.puppet-opnsense/opnsense2.example.com-config.yaml'),
              ['route', 'static', 'list', '-o', 'json']
            ],
            { custom_environment: { 'LC_ALL' => 'en_US.utf8' }, failonfail: true, combine: true },
          ).and_return(route_static_device_2.to_json)

        expect(provider.get(context, [])).to eq [
          {
            title: 'example route_static 1@opnsense1.example.com',
              device: 'opnsense1.example.com',
              network: '10.0.0.98/24',
              gateway: 'WAN_DHCP',
              descr: 'example route_static 1',
              disabled: true,
              uuid: '624cb3ca-3b76-4177-b736-4381c6525f37',
              ensure: 'present'
          },
          {
            title: 'example route_static 2@opnsense1.example.com',
              device: 'opnsense1.example.com',
              network: '192.168.1.0/24',
              gateway: 'NULL4',
              descr: 'example route_static 2',
              disabled: true,
              uuid: '002db5b7-791e-4e2f-8625-4350ee5ae8ac',
              ensure: 'present'
          },
          {
            title: 'example route_static 1@opnsense2.example.com',
              device: 'opnsense2.example.com',
              network: '10.0.4.0/24',
              gateway: 'NULL4',
              descr: 'example route_static 1',
              disabled: true,
              uuid: '731cb3ca-3b76-4177-b736-4381c6525f45',
              ensure: 'present'
          },
        ]
      end
    end

    context 'with filter device: opnsense2.example.com' do
      it 'returns all resources for opnsense2.example.com' do
        expect(Puppet::Util::Execution).to receive(:execute).and_return(route_static_device_2.to_json)
        expect(provider.get(context, [{ device: 'opnsense2.example.com' }])).to eq [
          {
            title: 'example route_static 1@opnsense2.example.com',
            device: 'opnsense2.example.com',
            network: '10.0.4.0/24',
            gateway: 'NULL4',
            descr: 'example route_static 1',
            disabled: true,
            
            uuid: '731cb3ca-3b76-4177-b736-4381c6525f45',
            ensure: 'present'
          },
        ]
      end
    end
  end

  describe 'create another_route_static@opnsense2.example.com' do
    it 'creates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved", "uuid": "1a2d6a8e-ed7a-4377-b723-e1582b2b2c18"}')

      provider.create(context, 'another_route_static@opnsense2.example.com',
                      device: 'opnsense2.example.com',
                      network: '10.0.4.0/2',
                      gateway: 'NULL4',
                      disabled: true,
                      ensure: 'present')
    end
  end

  describe 'update example route_static 1@opnsense2.example.com' do
    it 'updates the resource' do
      expect(Puppet::Util::Execution).to receive(:execute)
        .and_return('{"result": "saved"}')
      route_static_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = route_static_device_2

      provider.update(context, { descr: 'example route_static 1', device: 'opnsense2.example.com' },
                      device: 'opnsense2.example.com',
                      network: '10.0.5.0/24',
                      gateway: 'WAN_DHCP',
                      disabled: true,
                      
                      ensure: 'present')
    end
  end

  describe 'delete example route_static 1@opnsense2.example.com' do
    it 'deletes the resource' do
      expect(Puppet::Util::Execution).to receive(:execute).and_return('{"result": "deleted"}')
      route_static_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = route_static_device_2

      provider.delete(context, { descr: 'example route_static 1', device: 'opnsense2.example.com' })
    end
  end

  describe 'delete non existent route_static' do
    it 'throws puppet error' do
      route_static_device_2[0][:device] = 'opnsense2.example.com'
      provider.resource_list = route_static_device_2

      expect { provider.delete(context, { descr: 'non existent route_static', device: 'opnsense2.example.com' }) }
        .to raise_error(Puppet::Error)
    end
  end
end
