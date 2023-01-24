# frozen_string_literal: true

require 'spec_helper'
require 'pp'
require 'fakefs/spec_helpers'

ensure_module_defined('Puppet::Provider::OpnsenseDevice')
require 'puppet/provider/opnsense_device/opnsense_device'

RSpec.describe Puppet::Provider::OpnsenseDevice::OpnsenseDevice do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:sensitive_pw) { Puppet::Provider::OpnsenseSensitive.new('api_secret') }
  let(:sensitive_pw2) { Puppet::Provider::OpnsenseSensitive.new('api_secret2') }
  let(:devices) { ['opnsense1.example.com', 'opnsense2.example.com'] }
  let(:device_config) do
    {
      'api_key' => 'api_key',
        'api_secret' => 'api_secret',
        'ca' => '/path/to/ca',
        'ssl_verify' => false,
        'timeout' => 60,
        'url' => 'http://127.0.0.1/api'
    }
  end
  let(:device_config_yaml) do
    <<~FILE_CONTENT
      ---
      api_key: api_key
      api_secret: api_secret
      url: http://127.0.0.1/api
      timeout: 60
      ssl_verify: true
      ca: "/path/to/ca"
    FILE_CONTENT
  end
  let(:device_config_yaml2) do
    <<~FILE_CONTENT
      ---
      api_key: api_key2
      api_secret: api_secret2
      url: http://10.0.0.1/api
      timeout: 30
      ssl_verify: false
      ca: "/path/to/other/ca"
    FILE_CONTENT
  end
  let(:config_basedir) { File.expand_path('~/.puppet-opnsense') }
  let(:fakefs_root) do
    fixtures_dir = File.expand_path('../../../../../fixtures', __FILE__)
    File.join(fixtures_dir, 'unit/fakefs')
  end

  describe 'get' do
    include FakeFS::SpecHelpers
    before :each do
      FakeFS.activate!
      FakeFS::FileSystem.clone(fakefs_root)
      FakeFS::FileUtils.mkdir_p(config_basedir)
      FakeFS::FileUtils.cp("#{fakefs_root}/opnsense1.example.com-config.yaml", "#{config_basedir}/.")
      FakeFS::FileUtils.cp("#{fakefs_root}/opnsense2.example.com-config.yaml", "#{config_basedir}/.")
    end
    after :each do
      FakeFS.deactivate!
    end

    context 'with empty filter' do
      it 'returns all resources' do
        expect(provider.get(context, [])).to eq [
          {
            ensure: 'present',
              name: 'opnsense1.example.com',
              api_key: 'api_key',
              api_secret: sensitive_pw,
              url: 'https://127.0.0.1/api',
              timeout: 60,
              ssl_verify: false,
              ca: '/path/to/ca',
          },
          {
            ensure: 'present',
              name: 'opnsense2.example.com',
              api_key: 'api_key',
              api_secret: sensitive_pw2,
              url: 'https://127.0.0.1/api',
              timeout: 60,
              ssl_verify: true,
              ca: '/path/to/ca',
          },
        ]
      end
    end

    context 'with filter ["opnsense1.example.com"]' do
      it 'returns resource opnsense1.example.com' do
        expect(provider.get(context, ['opnsense1.example.com'])).to eq [
          {
            ensure: 'present',
              name: 'opnsense1.example.com',
              api_key: 'api_key',
              api_secret: sensitive_pw,
              url: 'https://127.0.0.1/api',
              timeout: 60,
              ssl_verify: false,
              ca: '/path/to/ca',
          },
        ]
      end
    end
  end

  describe 'create' do
    include FakeFS::SpecHelpers
    it 'creates the device configfile' do
      FakeFS.activate!
      FakeFS::FileSystem.clone(fakefs_root)
      FakeFS::FileUtils.mkdir_p(config_basedir)

      provider.create(context, 'opn.example.com',
                      name: 'opn.example.com',
                      api_key: 'api_key',
                      api_secret: sensitive_pw,
                      url: 'http://127.0.0.1/api',
                      timeout: 60,
                      ssl_verify: true,
                      ca: '/path/to/ca',
                      ensure: 'present')

      expect(FakeFS::File.read("#{config_basedir}/opn.example.com-config.yaml")).to include(device_config_yaml)

      FakeFS.deactivate!
    end
  end

  describe 'update' do
    include FakeFS::SpecHelpers
    it 'updates the device configfile' do
      FakeFS.activate!
      FakeFS::FileSystem.clone(fakefs_root)
      FakeFS::FileUtils.mkdir_p(config_basedir)

      provider.update(context, 'opn.example.com',
                      name: 'opn.example.com',
                      api_key: 'api_key2',
                      api_secret: sensitive_pw2,
                      url: 'http://10.0.0.1/api',
                      timeout: 30,
                      ssl_verify: false,
                      ca: '/path/to/other/ca',
                      ensure: 'present')

      expect(FakeFS::File.read("#{config_basedir}/opn.example.com-config.yaml")).to include(device_config_yaml2)

      FakeFS.deactivate!
    end
  end

  describe 'delete' do
    include FakeFS::SpecHelpers
    it 'deletes the device configfile' do
      FakeFS.activate!
      FakeFS::FileSystem.clone(fakefs_root)

      provider.delete(context, 'opn.example.com')

      expect(FakeFS::File.exist?("#{config_basedir}/opn.example.com-config.yaml")).to eq(false)
      FakeFS.deactivate!
    end
  end

  describe 'canonicalize' do
    it 're-encrypt api_secrets' do
      resources = [
        {
          ensure: 'present',
            name: 'opnsense1.example.com',
            api_key: 'api_key',
            api_secret: sensitive_pw,
            url: 'http://127.0.0.1/api',
            timeout: 60,
            ssl_verify: false,
            ca: '/path/to/ca',
        },
      ]
      # rubocop:disable RSpec/SubjectStub
      expect(provider).to receive(:_gen_pw).with('api_secret')

      provider.canonicalize(context, resources)
    end
  end

  describe 'get_device_names_by_filter' do
    context 'with filter ["opnsense1.example.com"]' do
      it 'returns the filter unmodified' do
        provider.get_device_names_by_filter(['opnsense1.example.com'])
      end
    end
  end
end
