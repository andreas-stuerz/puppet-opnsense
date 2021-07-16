# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_firewall_rule'

RSpec.describe 'the opnsense_firewall_rule type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_firewall_rule)).not_to be_nil
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:opnsense_firewall_rule).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'example rule on opnsense.example.com' do
    let(:fw_rule) do
      Puppet::Type.type(:opnsense_firewall_rule).new(
          name: 'example rule',
          device: 'opnsense.example.com',
          sequence: 1,
          action: 'pass',
          direction: 'in',
          ipprotocol: 'inet',
          interface: ['lan'],
          source_net: 'any',
          source_port: '',
          source_not: true,
          protocol: 'any',
          destination_net: 'any',
          destination_port: '',
          destination_not: true,
          description: 'example rule lan',
          gateway: '',
          quick: true,
          log: false,
          enabled: true,
          ensure: 'present',
      )
    end

    it 'accepts a name' do
      fw_rule[:name] = 'example rule renamed'
      expect(fw_rule[:name]).to eq('example rule renamed')
    end

    it 'accepts a device' do
      fw_rule[:device] = 'opnsense1.example.com'
      expect(fw_rule[:device]).to eq('opnsense1.example.com')
    end

    it 'accepts a sequence' do
      fw_rule[:sequence] = 2
      expect(fw_rule[:sequence]).to eq(2)
    end

    it 'accepts a action' do
      fw_rule[:action] = 'reject'
      expect(fw_rule[:action]).to eq('reject')
    end

    it 'accepts a direction' do
      fw_rule[:direction] = 'out'
      expect(fw_rule[:direction]).to eq('out')
    end

    it 'accepts interfaces' do
      fw_rule[:interface] = ['lan', 'wan']
      expect(fw_rule[:interface]).to eq(['lan', 'wan'])
    end

    it 'accepts a source_net' do
      fw_rule[:source_net] = '192.168.50.0/24'
      expect(fw_rule[:source_net]).to eq('192.168.50.0/24')
    end

    it 'accepts a source_port' do
      fw_rule[:source_port] = '10001'
      expect(fw_rule[:source_port]).to eq('10001')
    end

    it 'accepts source_not' do
      fw_rule[:source_not] = false
      expect(fw_rule[:source_not]).to eq(:false)
    end

    it 'accepts a protocol' do
      fw_rule[:source_port] = 'TCP'
      expect(fw_rule[:source_port]).to eq('TCP')
    end
    #
    it 'accepts a destination_net' do
      fw_rule[:destination_net] = '10.0.50.0/24'
      expect(fw_rule[:destination_net]).to eq('10.0.50.0/24')
    end

    it 'accepts a destination_port' do
      fw_rule[:destination_port] = 'https'
      expect(fw_rule[:destination_port]).to eq('https')
    end

    it 'accepts destination_not' do
      fw_rule[:destination_not] = false
      expect(fw_rule[:destination_not]).to eq(:false)
    end

    it 'accepts a description' do
      fw_rule[:description] = 'modified example'
      expect(fw_rule[:description]).to eq('modified example')
    end

    it 'accepts a gateway' do
      fw_rule[:gateway] = 'Null4'
      expect(fw_rule[:gateway]).to eq('Null4')
    end

    it 'accepts quick' do
      fw_rule[:quick] = false
      expect(fw_rule[:quick]).to eq(:false)
    end

    it 'accepts log' do
      fw_rule[:log] = true
      expect(fw_rule[:log]).to eq(:true)
    end

    it 'accepts enabled' do
      fw_rule[:enabled] = false
      expect(fw_rule[:enabled]).to eq(:false)
    end
  end
end
