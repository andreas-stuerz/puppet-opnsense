# frozen_string_literal: true

require_relative '../opnsense_provider'
require 'json'

# Implementation for the opnsense_firewall_rule type using the Resource API.
class Puppet::Provider::OpnsenseFirewallRule::OpnsenseFirewallRule < Puppet::Provider::OpnsenseProvider
  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [Array<Hash<Symbol>>] filter
  # @return [Array<Hash<Symbol>>]
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    _get_firewall_rules_from_devices(device_names)
  end

  # @param [Array<String>] devices
  # @return [Array<Hash<Symbol>>]
  def _get_firewall_rules_from_devices(devices)
    result = []
    devices.each do |device|
      rules = _rules_list(device)
      rules.each do |fw_rule|
        result.push(
            title: "#{fw_rule['sequence']} #{fw_rule['description']}@#{device}",
            sequence: fw_rule['sequence'],
            description: fw_rule['description'],
            device: device,
            uuid: fw_rule['uuid'],
            action: fw_rule['action'],
            interface: fw_rule['interface'].split(','),
            direction: fw_rule['direction'],
            quick: bool_from_value(fw_rule['quick']),
            ipprotocol: fw_rule['ipprotocol'],
            protocol: fw_rule['protocol'],
            source_net: fw_rule['source_net'],
            source_port: fw_rule['source_port'],
            source_not:  bool_from_value(fw_rule['source_not']),
            destination_net: fw_rule['destination_net'],
            destination_port: fw_rule['destination_port'],
            destination_not:  bool_from_value(fw_rule['destination_not']),
            gateway: fw_rule['gateway'],
            log:  bool_from_value(fw_rule['log']),
            enabled:  bool_from_value(fw_rule['enabled']),
            ensure: 'present',
          )
      end
    end
    result
  end

  # @param [String] device_name
  # @return [Array]
  def _rules_list(device_name)
    json_output = opn_cli_base_cmd(device_name, ['firewall', 'rule', 'list', '-o', 'json'])
    JSON.parse(json_output)
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

  private :_get_firewall_rules_from_devices
end
