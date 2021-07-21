# frozen_string_literal: true

require 'spec_helper'

ensure_module_defined('Puppet::Provider::OpnsenseFirewallRule')
require 'puppet/provider/opnsense_firewall_rule/opnsense_firewall_rule'

RSpec.describe Puppet::Provider::OpnsenseFirewallRule::OpnsenseFirewallRule do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }

  let(:rules_device_1) do
    [
      {
        "enabled": '1',
          "sequence": '1',
          "action": 'pass',
          "quick": '1',
          "interface": 'lan',
          "direction": 'in',
          "ipprotocol": 'inet',
          "protocol": 'TCP',
          "source_net": 'any',
          "source_not": '0',
          "source_port": '',
          "destination_net": 'any',
          "destination_not": '0',
          "destination_port": '',
          "gateway": '',
          "log": '0',
          "description": 'example rule1',
          "uuid": '624cb3ca-3b76-4177-b736-4381c6525f37'
      },
      {
        "enabled": '1',
          "sequence": '2',
          "action": 'block',
          "quick": '1',
          "interface": 'lan',
          "direction": 'in',
          "ipprotocol": 'inet',
          "protocol": 'TCP',
          "source_net": '192.168.61.1',
          "source_not": '0',
          "source_port": '',
          "destination_net": '192.168.70.0/24',
          "destination_not": '0',
          "destination_port": 'https',
          "gateway": '',
          "log": '0',
          "description": 'example rule 2',
          "uuid": '002db5b7-791e-4e2f-8625-4350ee5ae8ac'
      },
    ]
  end

  let(:rules_device_2) do
    [
        {
            "enabled": '1',
            "sequence": '1',
            "action": 'block',
            "quick": '1',
            "interface": 'lan',
            "direction": 'in',
            "ipprotocol": 'inet',
            "protocol": 'TCP',
            "source_net": '10.0.50.0/24',
            "source_not": '0',
            "source_port": '',
            "destination_net": 'any',
            "destination_not": '0',
            "destination_port": '',
            "gateway": '',
            "log": '0',
            "description": 'example rule1',
            "uuid": '624cb3ca-3b76-4177-b736-4381c6525f37'
        },
    ]

  end


  describe '#get' do
    context 'with empty filter' do
      it 'returns all resources' do
        expect(provider.get(context)).to eq [
          {
            name: 'foo',
            ensure: 'present',
          },
          {
            name: 'bar',
            ensure: 'present',
          },
        ]
      end
    end
  end

  # describe 'create(context, name, should)' do
  #   it 'creates the resource' do
  #     expect(context).to receive(:notice).with(%r{\ACreating 'a'})
  #
  #     provider.create(context, 'a', name: 'a', ensure: 'present')
  #   end
  # end
  #
  # describe 'update(context, name, should)' do
  #   it 'updates the resource' do
  #     expect(context).to receive(:notice).with(%r{\AUpdating 'foo'})
  #
  #     provider.update(context, 'foo', name: 'foo', ensure: 'present')
  #   end
  # end
  #
  # describe 'delete(context, name)' do
  #   it 'deletes the resource' do
  #     expect(context).to receive(:notice).with(%r{\ADeleting 'foo'})
  #
  #     provider.delete(context, 'foo')
  #   end
  # end
end
