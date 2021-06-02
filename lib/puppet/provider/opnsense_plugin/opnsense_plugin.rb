# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

# Implementation for the opnsense_plugin type using the Resource API.
class Puppet::Provider::OpnsensePlugin::OpnsensePlugin < Puppet::ResourceApi::SimpleProvider
  def opn_cli_cmd(context, *args)
    args.unshift('opn-cli')
    Puppet::Util::Execution.execute(args, failonfail: true,)
  end

  def get(context)
    pp context
    #opn_cli_cmd([])
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
