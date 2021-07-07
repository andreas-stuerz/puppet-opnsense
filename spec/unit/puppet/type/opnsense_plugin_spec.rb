# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_plugin'

RSpec.describe 'the opnsense_plugin type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_plugin)).not_to be_nil
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:opnsense_plugin).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'os-haproxy on opnsense.example.com' do
    let(:plugin) do
      Puppet::Type.type(:opnsense_plugin).new(
          name: 'os-haproxy',
          device: 'opnsense.example.com',
        )
    end

    it 'accepts a name' do
      plugin[:name] = 'os-acme-client'
      expect(plugin[:name]).to eq('os-acme-client')
    end

    it 'accepts a device' do
      plugin[:device] = 'opnsense.example.com'
      expect(plugin[:device]).to eq('opnsense.example.com')
    end
  end
end
