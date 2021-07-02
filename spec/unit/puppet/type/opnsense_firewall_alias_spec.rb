# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_firewall_alias'

RSpec.describe 'the opnsense_firewall_alias type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_firewall_alias)).not_to be_nil
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:opnsense_firewall_alias).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'my_alias on opnsense.example.com' do
    let(:fw_alias) do
      Puppet::Type.type(:opnsense_firewall_alias).new(
          name: 'my_alias',
          device: 'opnsense.example.com',
        )
    end

    it 'accepts a name' do
      fw_alias[:name] = 'my_alias'
      expect(fw_alias[:name]).to eq('my_alias')
    end

    it 'accepts a device' do
      fw_alias[:device] = 'opnsense.example.com'
      expect(fw_alias[:device]).to eq('opnsense.example.com')
    end
  end
end
