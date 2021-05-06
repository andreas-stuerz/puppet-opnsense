# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_device'

RSpec.describe 'the opnsense_device type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_device)).not_to be_nil
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:opnsense_device).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  context 'opnsense.example.com' do
    let(:device) do
      Puppet::Type.type(:opnsense_device).new(
          name: 'opnsense.example.com',
          url: 'https://opnsense.example.de/api',
          api_key: 'your_api_key',
          api_secret: Puppet::Pops::Types::PSensitiveType::Sensitive.new('your_api_secret'),
          timeout: 60,
          ssl_verify: true,
          ca: '/path/to/ca.pem',
        )
    end

    it 'accepts a name' do
      device[:name] = 'opn.example.de'
      expect(device[:name]).to eq('opn.example.de')
    end

    it 'accepts a url' do
      device[:url] = 'https://127.0.0.1/api'
      expect(device[:url]).to eq('https://127.0.0.1/api')
    end

    it 'accepts an api_key' do
      device[:api_key] = 'your_api_key2'
      expect(device[:api_key]).to eq('your_api_key2')
    end

    it 'accepts an api_secret' do
      device[:api_secret] = Puppet::Pops::Types::PSensitiveType::Sensitive.new('your_api_secret2')
      expect(device[:api_secret].unwrap).to eq('your_api_secret2')
    end

    it 'accepts a timeout' do
      device[:timeout] = 30
      expect(device[:timeout]).to eq(30)
    end

    it 'accepts a ssl_verify' do
      device[:ssl_verify] = false
      expect(device[:ssl_verify]).to eq(:false)
    end

    it 'accepts a ca' do
      device[:ca] = '/path/to/other/ca.pem'
      expect(device[:ca]).to eq('/path/to/other/ca.pem')
    end
  end
end
