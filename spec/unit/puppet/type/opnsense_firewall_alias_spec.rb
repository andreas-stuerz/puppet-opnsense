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

  context 'geoip_alias on opnsense.example.com' do
    let(:fw_alias) do
      Puppet::Type.type(:opnsense_firewall_alias).new(
          name: 'geoip_alias',
          device: 'opnsense.example.com',
          type: 'geoip',
          content: ['DE', 'GR'],
          description: 'Only german and greek IPv4 and IPV6 addresses',
          proto: 'IPv4,IPv6',
          counters: true,
          enabled: true,
        )
    end

    it 'accepts a name' do
      fw_alias[:name] = 'url_table_alias'
      expect(fw_alias[:name]).to eq('url_table_alias')
    end

    it 'accepts a device' do
      fw_alias[:device] = 'opnsense1.example.com'
      expect(fw_alias[:device]).to eq('opnsense1.example.com')
    end

    it 'accepts a type' do
      fw_alias[:type] = 'urltable'
      expect(fw_alias[:type]).to eq('urltable')
    end

    it 'accepts content' do
      fw_alias[:content] = ['https://www.spamhaus.org/drop/drop.txt', 'https://www.spamhaus.org/drop/edrop.txt']
      expect(fw_alias[:content])
        .to eq(['https://www.spamhaus.org/drop/drop.txt', 'https://www.spamhaus.org/drop/edrop.txt'])
    end

    it 'accepts a description' do
      fw_alias[:description] = 'Spamhaus block list'
      expect(fw_alias[:description]).to eq('Spamhaus block list')
    end

    it 'accepts a proto' do
      fw_alias[:proto] = ''
      expect(fw_alias[:proto]).to eq('')
    end

    it 'accepts a updatefreq as Float' do
      fw_alias[:updatefreq] = 0.5
      expect(fw_alias[:updatefreq]).to eq(0.5)
    end

    it 'accepts a updatefreq as Integer' do
      fw_alias[:updatefreq] = 0
      expect(fw_alias[:updatefreq]).to eq(0)
    end

    it 'accepts counters' do
      fw_alias[:counters] = true
      expect(fw_alias[:counters]).to eq(:true)
    end

    it 'accepts enabled' do
      fw_alias[:enabled] = false
      expect(fw_alias[:enabled]).to eq(:false)
    end
  end
end
