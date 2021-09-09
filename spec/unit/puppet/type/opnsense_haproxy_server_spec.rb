# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_haproxy_server'

RSpec.describe 'the opnsense_haproxy_server type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_haproxy_server)).not_to be_nil
  end
end
