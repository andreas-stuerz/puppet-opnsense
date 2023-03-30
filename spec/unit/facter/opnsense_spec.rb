# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/opnsense'

describe :opnsense, type: :fact do
  subject(:fact) { Facter.fact(:opnsense) }

  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('FreeBSD')
  end

  describe 'with confine kernel: FreeBSD' do
    context 'without binary opnsense-version' do
      it 'returns nil' do
        expect(Facter::Core::Execution).to receive(:which)
          .with('opnsense-version').at_least(:once)
          .and_return(nil)
        expect(fact.value).to eq(nil)
      end
    end

    context 'with binary opnsense-version' do
      it 'returns a value' do
        expect(Facter::Core::Execution).to receive(:which)
          .with('opnsense-version').at_least(:once)
          .and_return('/usr/local/sbin/opnsense-version')

        expect(Facter::Core::Execution).to receive(:exec)
          .with('/usr/local/sbin/opnsense-version -NAVvfH')
          .and_return("OPNsense amd64 23.1 23.1_6 OpenSSL 6621e1999\n")

        expect(Facter::Core::Execution).to receive(:which)
          .with('pluginctl')
          .and_return('/usr/local/sbin/pluginctl')

        expect(Facter::Core::Execution).to receive(:exec)
          .with('/usr/local/sbin/pluginctl -g system.firmware.plugins')
          .and_return("os-virtualbox,os-puppet-agent-devel,os-firewall,os-haproxy\n")

        expect(fact.value).to eq(
          {
            'name' => 'OPNsense',
              'architecture' => 'amd64',
              'release' => {
                'major' => '23.1',
                  'full' => '23.1_6',
                  'minor' => nil,
                  'flavour' => 'OpenSSL',
                  'hash' => '6621e1999',
              },
              'plugins' => [
                'os-virtualbox',
                'os-puppet-agent-devel',
                'os-firewall',
                'os-haproxy',
              ]
          },
        )
      end
    end
  end
end
