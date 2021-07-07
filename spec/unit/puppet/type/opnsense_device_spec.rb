# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_device'

RSpec.describe 'the opnsense_device type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_device)).not_to be_nil
  end
end
