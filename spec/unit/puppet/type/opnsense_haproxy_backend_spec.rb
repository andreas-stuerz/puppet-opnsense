# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_haproxy_backend'

RSpec.describe 'the opnsense_haproxy_backend type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_haproxy_backend)).not_to be_nil
  end
end
