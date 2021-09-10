# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_firewall_alias type using the Resource API.
class Puppet::Provider::OpnsenseFirewallAlias::OpnsenseFirewallAlias < Puppet::Provider::OpnsenseProvider
  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [Array<Hash<Symbol>>] filter
  # @return [Array<Hash<Symbol>>]
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    _get_from_devices(device_names)
  end

  # @param [Array<String>] devices
  # @return [Array<Hash<Symbol>>]
  def _get_from_devices(devices)
    result = []
    devices.each do |device|
      aliases = get_opn_cli_json_list(device, 'firewall', 'alias')
      aliases.each do |fw_alias|
        result.push(
            title: fw_alias['name'] + '@' + device,
            name: fw_alias['name'],
            device: device,
            type: fw_alias['type'],
            description: fw_alias['description'],
            content: fw_alias['content'].split(','),
            proto: fw_alias['proto'],
            updatefreq: fw_alias['updatefreq'].empty? ? '' : fw_alias['updatefreq'].to_f,
            counters: bool_from_value(fw_alias['counters']),
            enabled: bool_from_value(fw_alias['enabled']),
            ensure: 'present',
          )
      end
    end
    result
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def create(_context, _name, should)
    args = _get_command_args('create', should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args, '-o', 'json')
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def update(_context, _name, should)
    args = _get_command_args('update', should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args, '-o', 'json')
  end

  # @param [Integer] mode
  # @param [Hash<Symbol>] should
  # @return [Array<String>]
  def _get_command_args(mode, should)
    args = ['firewall', 'alias', mode, should[:name]]
    args.push('-t', should[:type])
    args.push('-d', should[:description])
    args.push('-C', should[:content].join(','))
    args.push('-p', should[:proto]) if should[:proto]
    args.push('-u', should[:updatefreq].to_f) if should[:updatefreq]
    args.push('--counters') if bool_from_value(should[:counters]) == true
    args.push('--no-counters') if bool_from_value(should[:counters]) == false
    args.push('--enabled') if  bool_from_value(should[:enabled]) == true
    args.push('--disabled') if bool_from_value(should[:enabled]) == false

    args
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def delete(_context, name)
    alias_name = name.fetch(:name).to_s
    device_name = name.fetch(:device).to_s
    opn_cli_base_cmd(device_name, ['firewall', 'alias', 'delete', alias_name, '-o', 'json'])
  end
  #
  private :_get_from_devices, :_get_command_args
end
