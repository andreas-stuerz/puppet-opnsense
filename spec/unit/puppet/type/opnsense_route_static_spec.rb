# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_route_static'

RSpec.describe 'the opnsense_route_static type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_route_static)).not_to be_nil
  end

  it 'requires a title' do
    expect {
      Puppet::Type.type(:opnsense_route_static).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'example route static on opnsense.example.com' do
    let(:route_static) do
      Puppet::Type.type(:opnsense_route_static).new(
        name: 'example route static',
        device: 'opnsense.example.com',
        network: '10.0.4.0/2',
        gateway: 'NULL4',
        disabled: true,
        ensure: 'present',
      )
    end

    it 'accepts network' do
      route_static[:network] = '10.0.5.0/2'
      expect(route_static[:network]).to eq('10.0.5.0/2')
    end

    it 'accepts gateway' do
      route_static[:gateway] = 'WAN_DHCP'
      expect(route_static[:gateway]).to eq('WAN_DHCP')
    end

    it 'accepts descr' do
      route_static[:descr] = 'a new description'
      expect(route_static[:descr]).to eq('a new description')
    end

    it 'accepts disabled' do
      route_static[:disabled] = false
      expect(route_static[:disabled]).to eq(:false)
    end
  end
end
