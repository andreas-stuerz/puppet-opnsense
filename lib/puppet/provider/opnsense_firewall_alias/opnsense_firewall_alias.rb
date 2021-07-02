# frozen_string_literal: true

require_relative '../opnsense_provider'
require 'json'

# Implementation for the opnsense_firewall_alias type using the Resource API.
class Puppet::Provider::OpnsenseFirewallAlias::OpnsenseFirewallAlias < Puppet::Provider::OpnsenseProvider
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    get_firewall_aliases_from_devices(device_names)
  end

  def get_firewall_aliases_from_devices(devices)
    result = []

    devices.each do |device|
      aliases = aliases_list(device)
      aliases.each do |fw_alias|
        result.push(
            title: fw_alias['name'] + '@' + device,
            name: fw_alias['name'],
            device: device,
            type: fw_alias['type'],
            description: fw_alias['description'],
            content: fw_alias['content'],
            proto: fw_alias['proto'],
            updatefreq: fw_alias['updatefreq'],
            counters: fw_alias['counters'],
            enabled: fw_alias['enabled'],
            ensure: 'present',
        )
      end
    end
    result
  end

  def aliases_list(device_name)
    json_output = opn_cli_base_cmd(device_name, ['firewall', 'alias', 'list', '-o', 'json'])
    JSON.parse(json_output)
  end

  def create(context, name, should)
    args = get_command_args('create', should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args)
  end

  def update(context, name, should)
    args = get_command_args('update', should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args)
  end

  def get_command_args(mode, should)
    args = ['firewall', 'alias', mode, should[:name]]
    args.push('-t', should[:type])
    args.push('-d', should[:description])
    args.push('-C', should[:content])
    args.push('-p', should[:proto]) if should[:proto]
    args.push('-u', should[:updatefreq].to_f) if should[:updatefreq]
    args.push('--counters') if bool_from_value(should[:counters]) == true
    args.push('--no-counters') if bool_from_value(should[:counters]) == false
    args.push('--enabled') if  bool_from_value(should[:enabled]) == true
    args.push('--disabled') if  bool_from_value(should[:enabled]) == false

    args
  end

  def delete(context, name)
    alias_name = name.fetch(:name).to_s
    device_name = name.fetch(:device).to_s
    opn_cli_base_cmd(device_name, ['firewall', 'alias', 'delete', alias_name])
  end
end
