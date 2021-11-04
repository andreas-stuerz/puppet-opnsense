# frozen_string_literal: true

require 'spec_helper'

describe 'opnsense::client::haproxy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        hash_from_fixture_yaml_file('unit/classes/opnsense/haproxy_exported_resources.yaml')
      end
      let(:node) { 'client1.example.com' }

      describe 'compiles the catalog' do
        it { is_expected.to compile.with_all_deps }
      end

      describe 'export haproxy servers as exported resources' do
        it {
          expect(exported_resources)
            .to contain_opnsense_haproxy_server('server1@opnsense1.example.com').with(
                  'description' => 'client1.example.com - first local server',
                  'tag' => 'opnsense1.example.com',
                )
          expect(exported_resources)
            .to contain_opnsense_haproxy_server('server2@opnsense1.example.com').with(
                  'description' => 'client1.example.com - second local server',
                  'tag' => 'opnsense1.example.com',
                )
        }
      end

      describe 'export haproxy backends as exported resources' do
        it {
          expect(exported_resources)
            .to contain_opnsense_haproxy_backend('localhost_backend@opnsense1.example.com').with(
                'description' => 'client1.example.com - local server backend',
                'tag' => 'opnsense1.example.com',
              )
        }
      end

      describe 'export haproxy frontend as exported resources' do
        it {
          expect(exported_resources)
            .to contain_opnsense_haproxy_frontend('localhost_frontend@opnsense1.example.com').with(
                  'description' => 'client1.example.com - local frontend',
                  'tag' => 'opnsense1.example.com',
                )
        }
      end
    end
  end
end
