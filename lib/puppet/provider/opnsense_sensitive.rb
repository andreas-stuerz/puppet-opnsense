# A Puppet Language type that makes the OpnsenseSensitive Type comparable
#
class Puppet::Provider::OpnsenseSensitive < Puppet::Pops::Types::PSensitiveType::Sensitive
  # @param [Puppet::Pops::Types::PSensitiveType::Sensitive] other
  # @return [TrueClass]
  def ==(other)
    return true if other.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive) && unwrap == other.unwrap
  end
end
