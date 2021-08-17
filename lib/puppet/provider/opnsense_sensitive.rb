# A Puppet Language type that makes the OpnsenseSensitive Type comparable
#
class Puppet::Provider::OpnsenseSensitive < Puppet::Pops::Types::PSensitiveType::Sensitive
  # @param [Puppet::Pops::Types::PSensitiveType::Sensitive] other
  # @return [TrueClass]
  def ==(other)
    return true if other.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive) && unwrap == other.unwrap
  end

  # YAML serialization helper for Psych.
  # @param [Object] coder
  def encode_with(coder)
    coder.tag = nil
    coder.scalar = 'Puppet::Provider::OpnsenseSensitive <<encrypted>>'
  end
end
