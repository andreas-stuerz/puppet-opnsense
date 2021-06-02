# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

ensure_module_defined('Puppet::Provider::OpnsenseDevice')
require 'puppet/provider/opnsense_device/opnsense_device'

RSpec.describe Puppet::Provider::OpnsenseDevice::OpnsenseDevice do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:sensitive_pw) { Puppet::Provider::OpnsenseDevice::Sensitive.new('api_secret') }
  let(:sensitive_pw2) { Puppet::Provider::OpnsenseDevice::Sensitive.new('api_secret2') }
  let(:config_basedir) { File.expand_path('~/.puppet-opnsense') }

  before :each do
    allow(File).to receive(:exists?) { true }
    allow(File).to receive(:readable?) { true }
    allow(Dir).to receive(:glob) {
      ["#{config_basedir}/opnsense.example.com-config.yaml", "#{config_basedir}/opn.sense.it-config.yaml"]
    }
    allow(FileUtils).to receive(:rm) { true }
    allow(provider).to receive(:read_yaml) {
      {
          'api_key' => 'api_key',
          'api_secret' => 'api_secret',
          'url' => 'http://127.0.0.1/api',
          'timeout' => 60,
          'ssl_verify' => false,
          'ca' => '/path/to/ca'
      }
    }
  end

  describe '#get' do
    it 'processes resources' do
      expect(provider.get(context, [])).to eq [
        {
          ensure: 'present',
            name: 'opnsense.example.com',
            api_key: 'api_key',
            api_secret: sensitive_pw,
            url: 'http://127.0.0.1/api',
            timeout: 60,
            ssl_verify: false,
            ca: '/path/to/ca',
        },
        {
          ensure: 'present',
            name: 'opn.sense.it',
            api_key: 'api_key',
            api_secret: sensitive_pw,
            url: 'http://127.0.0.1/api',
            timeout: 60,
            ssl_verify: false,
            ca: '/path/to/ca',
        },
      ]
    end
  end

  describe 'create(context, name, should)' do
    it 'creates the resource' do
      expect(provider).to receive(:write_yaml)
        .with(
                                  "#{config_basedir}/opn.example.com-config.yaml",
                                  {
                                    'api_key' => 'api_key',
                                      'api_secret' => 'api_secret',
                                      'ca' => '/path/to/ca',
                                      'ssl_verify' => true,
                                      'timeout' => 60,
                                      'url' => 'http://127.0.0.1/api'
                                  },
                                )
        .and_return(true)

      provider.create(context, 'opn.example.com',
                      name: 'opn.example.com',
                      api_key: 'api_key',
                      api_secret: sensitive_pw,
                      url: 'http://127.0.0.1/api',
                      timeout: 60,
                      ssl_verify: true,
                      ca: '/path/to/ca',
                      ensure: 'present')
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the resource' do
      expect(provider).to receive(:write_yaml)
        .with(
                                  "#{config_basedir}/opn.example.com-config.yaml",
                                  {
                                    'api_key' => 'api_key2',
                                      'api_secret' => 'api_secret2',
                                      'ca' => '/path/to/other/ca',
                                      'ssl_verify' => false,
                                      'timeout' => 30,
                                      'url' => 'http://10.0.0.1/api'
                                  },
                                )
        .and_return(true)

      provider.update(context, 'opn.example.com',
                      name: 'opn.example.com',
                      api_key: 'api_key2',
                      api_secret: sensitive_pw2,
                      url: 'http://10.0.0.1/api',
                      timeout: 30,
                      ssl_verify: false,
                      ca: '/path/to/other/ca',
                      ensure: 'present')
    end
  end

  describe 'delete(context, name)' do
    it 'deletes the resource' do
      provider.delete(context, 'opn.example.com')
    end
  end
end
