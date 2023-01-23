# frozen_string_literal: true

require 'spec_helper'
require 'fileutils'

ensure_module_defined('Puppet::Provider::OpnsensePlugin')
require 'puppet/provider/opnsense_provider'

RSpec.describe Puppet::Provider::OpnsenseProvider do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:execution_error) do
    Puppet::ExecutionFailure.new(
      "Error: {'result': 'failed', 'validations': {'rule.interface': 'option not in list'}}",
    )
  end

  describe 'opn_cli_base_cmd' do
    it 'execute an opn-cli command' do
      expect(File).to receive(:expand_path).and_return('/tmp')
      expect(Puppet::Util::Execution).to receive(:execute)
        .with(['opn-cli', '-c', '/tmp/opnsense.example.com-config.yaml', 'plugin', 'installed', '-c', 'name'],
              failonfail: true,
              combine: true,
              custom_environment: { 'LC_ALL' => 'en_US.utf8' })
        .and_return("os-acme-client\nos-clamav")

      expect(
          provider.opn_cli_base_cmd('opnsense.example.com', 'plugin', 'installed', '-c', 'name'),
        )
        .to eq "os-acme-client\nos-clamav"
    end

    it 'an opn-cli command fails' do
      expect(Puppet::Util::Execution).to receive(:execute).and_raise(execution_error)
      expect {
        provider.opn_cli_base_cmd('opnsense.example.com', 'plugin', 'install', 'non_existing')
      }.to raise_error(
         Puppet::Error,
         "Error: {'result': 'failed', 'validations': {'rule.interface': 'option not in list'}}",
       )
    end
  end

  describe 'get_configured_devices' do
    it 'returns an array with device names read via glob pattern from fs' do
      expect(Dir).to receive(:glob)
        .and_return(['/tmp/opnsense1.example.com-config.yaml', '/tmp/opnsense2.example.com-config.yaml'])

      expect(provider.get_configured_devices).to eq ['opnsense1.example.com', 'opnsense2.example.com']
    end
  end

  describe 'bool_from_value' do
    it 'raise ArgumentError if value will not result in boolean' do
      expect { provider.bool_from_value('something') }.to raise_error(ArgumentError, %r{invalid value for Boolean()})
    end
  end

  describe 'unknow resource type' do
    it 'raise ArgumentError if resource type is unknown' do
      expect {
        provider.resource_type = 'unknown'
        provider._fetch_resource_list(['opnsense.example.com'])
      }.to raise_error(Puppet::ResourceError, %r{Unknown resource type})
    end
  end
end
