# frozen_string_literal: true

require 'spec_helper'
require 'puppet/provider/opnsense_sensitive'
require 'psych'

RSpec.describe Puppet::Provider::OpnsenseSensitive do
  subject(:sensitive) { described_class.new('secret') }

  describe 'Puppet::Provider::OpnsenseSensitive' do
    it 'encodes its value correctly into transactionstore.yaml' do
      psych_encoded = Psych.load(Psych.dump(sensitive))
      expect(psych_encoded).to eq 'Puppet::Provider::OpnsenseSensitive <<encrypted>>'
    end
  end
end
