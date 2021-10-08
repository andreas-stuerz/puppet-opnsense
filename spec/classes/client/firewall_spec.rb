# frozen_string_literal: true

require 'spec_helper'

describe 'opnsense::client::firewall' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        hash_from_fixture_yaml_file('unit/classes/opnsense/firewall_exported_resources.yaml')
      end
      let(:node) { 'client1.example.com' }

      describe 'compiles the catalog' do
        it { is_expected.to compile.with_all_deps }
      end

      describe 'export firewall aliases as exported resources' do
        it {
          expect(exported_resources)
            .to contain_opnsense_firewall_alias('mac_alias_from_client@opnsense1.example.com').with(
                  'description' => 'client1.example.com - My MAC address or partial mac addresses',
                  'tag' => 'opnsense1.example.com',
                )
          expect(exported_resources)
            .to contain_opnsense_firewall_alias('mac_alias_from_client@opnsense2.example.com').with(
                'description' => 'client1.example.com - My MAC address or partial mac addresses',
                'tag' => 'opnsense2.example.com',
              )
        }
      end

      describe 'export firewall rules as exported resources' do
        it {
          expect(exported_resources)
            .to contain_opnsense_firewall_rule('client1.example.com - allow http@opnsense1.example.com').with(
                  'tag' => 'opnsense1.example.com',
                )
          expect(exported_resources)
            .to contain_opnsense_firewall_rule('client1.example.com - allow https@opnsense1.example.com').with(
              'tag' => 'opnsense1.example.com',
            )
          expect(exported_resources)
            .to contain_opnsense_firewall_rule('client1.example.com - allow https@opnsense2.example.com').with(
              'tag' => 'opnsense2.example.com',
            )
        }
      end
    end
  end
end
