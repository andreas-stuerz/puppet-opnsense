# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_firewall_rule'

RSpec.describe 'the opnsense_firewall_rule type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_firewall_rule)).not_to be_nil
  end
end
