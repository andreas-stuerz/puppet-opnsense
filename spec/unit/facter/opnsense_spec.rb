# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/opnsense'

describe :opnsense, type: :fact do
  subject(:fact) { Facter.fact(:opnsense) }

  before :each do
    Facter.flush
    allow(Facter.fact(:kernel)).to receive(:value).and_return('FreeBSD')
  end

  describe 'with confine kernel: FreeBSD' do
    context 'without binary opnsense-version' do
      it 'returns nil' do
        expect(Facter::Util::Resolution).to receive(:which)
          .with('opnsense-version')
          .and_return(nil)
        expect(fact.value).to eq(nil)
      end
    end

    context 'with binary opnsense-version' do
      it 'returns a value' do
        expect(Facter::Util::Resolution).to receive(:which)
          .with('opnsense-version')
          .and_return('/usr/local/sbin/opnsense-version')

        expect(Facter::Util::Resolution).to receive(:exec)
          .with('/usr/local/sbin/opnsense-version -NAVvfH')
          .and_return("OPNsense amd64 21.7 21.7.1 OpenSSL ec466867c\n")

        expect(Facter::Util::Resolution).to receive(:which)
          .with('pluginctl')
          .and_return('/usr/local/sbin/pluginctl')

        expect(Facter::Util::Resolution).to receive(:exec)
          .with('/usr/local/sbin/pluginctl -g system.firmware.plugins')
          .and_return("os-virtualbox,os-puppet-agent-devel,os-firewall,os-haproxy\n")

        expect(fact.value).to eq(
          {
            'name' => 'OPNsense',
              'architecture' => 'amd64',
              'release' => {
                'major' => '21.7',
                  'full' => '21.7.1',
                  'minor' => '1',
                  'flavour' => 'OpenSSL',
                  'hash' => 'ec466867c',
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
