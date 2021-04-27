# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_plugin'

RSpec.describe 'the opnsense_plugin type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_plugin)).not_to be_nil
  end
end
