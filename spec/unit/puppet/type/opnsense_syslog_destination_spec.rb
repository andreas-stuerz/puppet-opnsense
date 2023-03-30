# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_syslog_destination'

RSpec.describe 'the opnsense_syslog_destination type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_syslog_destination)).not_to be_nil
  end

  it 'requires a title' do
    expect {
      Puppet::Type.type(:opnsense_syslog_destination).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'example syslog destination on opnsense.example.com' do
    let(:syslog_destination) do
      Puppet::Type.type(:opnsense_syslog_destination).new(
        name: 'example syslog destination',
        device: 'opnsense.example.com',
        enabled: true,
        transport: 'tls4',
        program: 'ntp,ntpdate,ntpd',
        level: ['info', 'notice', 'warn', 'err', 'crit', 'alert', 'emerg'],
        facility: ['ntp', 'security', 'console'],
        hostname: '10.0.0.2',
        certificate: '60cc4641eb577',
        port: '514',
        rfc5424: true,
        description: 'example syslog destination',
        ensure: 'present',
      )
    end

    it 'accepts enabled' do
      syslog_destination[:enabled] = false
      expect(syslog_destination[:enabled]).to eq(:false)
    end

    it 'accepts transport' do
      syslog_destination[:transport] = 'tcp4'
      expect(syslog_destination[:transport]).to eq('tcp4')
    end

    it 'accepts program' do
      syslog_destination[:program] = 'ntp'
      expect(syslog_destination[:program]).to eq('ntp')
    end

    it 'accepts level' do
      syslog_destination[:level] = ['crit', 'alert', 'emerg']
      expect(syslog_destination[:level]).to eq(['crit', 'alert', 'emerg'])
    end

    it 'accepts facility' do
      syslog_destination[:facility] = ['ntp']
      expect(syslog_destination[:facility]).to eq(['ntp'])
    end

    it 'accepts hostname' do
      syslog_destination[:hostname] = '10.0.0.1'
      expect(syslog_destination[:hostname]).to eq('10.0.0.1')
    end

    it 'accepts certificate' do
      syslog_destination[:certificate] = ''
      expect(syslog_destination[:certificate]).to eq('')
    end

    it 'accepts port' do
      syslog_destination[:port] = '1514'
      expect(syslog_destination[:port]).to eq('1514')
    end

    it 'accepts rfc5424' do
      syslog_destination[:rfc5424] = false
      expect(syslog_destination[:rfc5424]).to eq(:false)
    end

    it 'accepts description' do
      syslog_destination[:description] = 'a new description'
      expect(syslog_destination[:description]).to eq('a new description')
    end
  end
end
