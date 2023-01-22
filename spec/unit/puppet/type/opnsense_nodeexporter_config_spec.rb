# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/opnsense_nodeexporter_config'

RSpec.describe 'the opnsense_nodeexporter_config type' do
  it 'loads' do
    expect(Puppet::Type.type(:opnsense_nodeexporter_config)).not_to be_nil
  end
end
