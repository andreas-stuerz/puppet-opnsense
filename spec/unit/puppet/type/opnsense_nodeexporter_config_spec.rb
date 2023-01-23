# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_nodeexporter_config'

RSpec.describe 'the opnsense_nodeexporter_config type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_nodeexporter_config)).not_to be_nil
  end

  it 'requires a title' do
    expect {
      Puppet::Type.type(:opnsense_nodeexporter_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'example nodeexporter config on opnsense.example.com' do
    let(:nodeexporter_config) do
      Puppet::Type.type(:opnsense_nodeexporter_config).new(
        enabled: true,
        listen_address: '0.0.0.0',
        listen_port: '9100',
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

    it 'accepts enabled' do
      nodeexporter_config[:enabled] = false
      expect(nodeexporter_config[:enabled]).to eq(:false)
    end

    it 'accepts listen_address' do
      nodeexporter_config[:listen_address] = '192.168.0.1'
      expect(nodeexporter_config[:listen_address]).to eq('192.168.0.1')
    end

    it 'accepts listen_port' do
      nodeexporter_config[:listen_port] = '9105'
      expect(nodeexporter_config[:listen_port]).to eq('9105')
    end

    it 'accepts cpu' do
      nodeexporter_config[:cpu] = true
      expect(nodeexporter_config[:cpu]).to eq(:true)
    end

    it 'accepts exec' do
      nodeexporter_config[:exec] = true
      expect(nodeexporter_config[:exec]).to eq(:true)
    end

    it 'accepts filesystem' do
      nodeexporter_config[:filesystem] = true
      expect(nodeexporter_config[:filesystem]).to eq(:true)
    end

    it 'accepts loadavg' do
      nodeexporter_config[:loadavg] = true
      expect(nodeexporter_config[:loadavg]).to eq(:true)
    end

    it 'accepts meminfo' do
      nodeexporter_config[:meminfo] = true
      expect(nodeexporter_config[:meminfo]).to eq(:true)
    end

    it 'accepts netdev' do
      nodeexporter_config[:netdev] = true
      expect(nodeexporter_config[:netdev]).to eq(:true)
    end

    it 'accepts time' do
      nodeexporter_config[:time] = true
      expect(nodeexporter_config[:time]).to eq(:true)
    end

    it 'accepts devstat' do
      nodeexporter_config[:devstat] = true
      expect(nodeexporter_config[:devstat]).to eq(:true)
    end

    it 'accepts interrupts' do
      nodeexporter_config[:interrupts] = true
      expect(nodeexporter_config[:interrupts]).to eq(:true)
    end

    it 'accepts ntp' do
      nodeexporter_config[:ntp] = true
      expect(nodeexporter_config[:ntp]).to eq(:true)
    end

    it 'accepts zfs' do
      nodeexporter_config[:zfs] = true
      expect(nodeexporter_config[:zfs]).to eq(:true)
    end
  end
end
