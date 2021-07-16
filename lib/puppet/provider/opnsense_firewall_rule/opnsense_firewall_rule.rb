# frozen_string_literal: true

require_relative '../opnsense_provider'
require 'json'

# Implementation for the opnsense_firewall_rule type using the Resource API.
class Puppet::Provider::OpnsenseFirewallRule::OpnsenseFirewallRule < Puppet::Provider::OpnsenseProvider
  def get(context)
    context.debug('Returning pre-canned example data')
    [
      {
        name: 'foo',
        ensure: 'present',
      },
      {
        name: 'bar',
        ensure: 'present',
      },
    ]
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
  end
end
