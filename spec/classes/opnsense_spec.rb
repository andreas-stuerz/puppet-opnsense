# frozen_string_literal: true

require 'spec_helper'

puppet_debug = false
RSpec.configure do |c|
  if puppet_debug
    c.before(:each) do
      Puppet::Util::Log.level = :debug
      Puppet::Util::Log.newdestination(:console)
    end
  end
end

describe 'opnsense' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      describe 'compiles the catalog' do
        it { is_expected.to compile.with_all_deps }
      end

      describe 'could manage local firewall' do
        let(:node) { 'opnsense.example.com' }
        let(:params) do
          hash_from_fixture_yaml_file('unit/classes/opnsense/local_resources.yaml')
        end

        it {
          is_expected.to contain_opnsense_device('opnsense.example.com').with(
              'ensure' => 'present',
            )

          is_expected.to contain_opnsense_plugin('os-acme-client').with(
              'device' => 'opnsense.example.com',
            )
          is_expected.to contain_opnsense_plugin('os-firewall').with(
              'device' => 'opnsense.example.com',
            )
          is_expected.to contain_opnsense_plugin('os-haproxy').with(
              'device' => 'opnsense.example.com',
              'ensure' => 'absent',
            )

          is_expected.to contain_opnsense_firewall_alias('hosts_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_alias('network_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_alias('ports_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_alias('url_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_alias('url_table_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_alias('geoip_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_alias('networkgroup_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_alias('mac_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_alias('external_alias@opnsense.example.com')
          is_expected.to contain_opnsense_firewall_rule(
                     'opnsense.example.com api manager - allow all from lan and wan@opnsense.example.com',
                   )
        }
      end

      describe 'with default CA settings' do
        it { is_expected.to contain_file('Symlink opn-cli CA file to system-wide CA certificates').with_ensure('link') }
        it { is_expected.to contain_file('Create opn-cli config directory').with_ensure('directory') }

        it { is_expected.not_to contain_file('Create opn-cli CA file with custom CA content') }
      end

      describe 'with custom CA settings' do
        let(:params) do
          {
            use_system_ca: false,
            ca_content: '-----BEGIN CERTIFICATE-----
AAAAAABBBBBBBBBCCCCCCCCCCDDDDDDDDDDDEEEEEEEEEEEFFFFFFFFFGGGGGGGG
-----END CERTIFICATE-----',
          }
        end

        describe 'compiles the catalog' do
          it { is_expected.to compile.with_all_deps }
        end

        describe 'can manage the CA file' do
          it { is_expected.to contain_file('Create opn-cli CA file with custom CA content').with_ensure('file') }
          it { is_expected.to contain_file('Create opn-cli CA file with custom CA content').with_content(%r{.*AAAAAABBBBBBBBBCCCCCCCCCCDDDDDDDDDDDEEEEEEEEEEEFFFFFFFFFGGGGGGGG.*}) }

          it { is_expected.not_to contain_file('Symlink opn-cli CA file to system-wide CA certificates') }
        end
      end

      describe 'with CA settings disabled' do
        let(:params) do
          {
            manage_ca: false,
          }
        end

        it { is_expected.not_to contain_file('Create opn-cli config directory') }
        it { is_expected.not_to contain_file('Symlink opn-cli CA file to system-wide CA certificates') }
        it { is_expected.not_to contain_file('Create opn-cli CA file with custom CA content') }
      end
    end
  end
end
