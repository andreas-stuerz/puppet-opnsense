# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_firewall_alias'

RSpec.describe 'the opnsense_firewall_alias type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_firewall_alias)).not_to be_nil
  end
end
