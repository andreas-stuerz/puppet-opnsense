# A Puppet Language type that makes the OpnsenseSensitive Type comparable
#
class Puppet::Provider::OpnsenseSensitive < Puppet::Pops::Types::PSensitiveType::Sensitive
  # @param [Puppet::Pops::Types::PSensitiveType::Sensitive] other
  # @return [TrueClass]
  def ==(other)
    return true if other.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive) && unwrap == other.unwrap
  end

  # The transactionstore uses psych to dump yaml to the cache file.
  # This lets us control how that is serialized.
  # @param [Hash] coder
  def encode_with(coder)
    coder.tag = nil
    coder.scalar = 'Puppet::Provider::OpnsenseSensitive <<encrypted>>'
  end
end
