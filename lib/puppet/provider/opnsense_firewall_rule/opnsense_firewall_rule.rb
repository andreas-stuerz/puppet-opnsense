# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))
require 'json'

# Implementation for the opnsense_firewall_rule type using the Resource API.
class Puppet::Provider::OpnsenseFirewallRule::OpnsenseFirewallRule < Puppet::Provider::OpnsenseProvider
  # writer for testing
  attr_writer :resource_list
  # @return [void]
  def initialize
    super
    @resource_list = []
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [Array<Hash<Symbol>>] filter
  # @return [Array<Hash<Symbol>>]
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    _fetch_resource_list(device_names)
    @resource_list
  end

  # @param [Array<String>] device_names
  # @return [void]
  def _fetch_resource_list(device_names)
    @resource_list = _get_firewall_rules_from_devices(device_names)
  end

  # @param [Array<String>] devices
  # @return [Array<Hash<Symbol>>]
  def _get_firewall_rules_from_devices(devices)
    result = []
    devices.each do |device|
      rules = _rules_list(device)
      rules.each do |fw_rule|
        result.push(
            title: "#{fw_rule['description']}@#{device}",
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

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def create(_context, _name, should)
    args = _get_command_args('create', should[:sequence], should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args, '-o', 'json')
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def update(_context, name, should)
    uuid = _find_uuid_by_namevars(name)
    args = _get_command_args('update', uuid, should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def delete(_context, name)
    uuid = _find_uuid_by_namevars(name)
    device_name = name.fetch(:device).to_s
    opn_cli_base_cmd(device_name, ['firewall', 'rule', 'delete', uuid, '-o', 'json'])
  end

  # @param [hash] namevars
  # @return [String] uuid
  def _find_uuid_by_namevars(namevars)
    resource_found = @resource_list.find do |resource|
      resource[:device] == namevars[:device] && resource[:description] == namevars[:description]
    end
    unless resource_found
      raise Puppet::ResourceError, "Could not find uuid for #{namevars}"
    end
    resource_found[:uuid]
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] should
  # @return [Array<String>]
  def _get_command_args(mode, id, should)
    args = ['firewall', 'rule', mode, id]
    args.push('-s', should[:sequence]) if mode == 'update'
    args.push('--description', should[:description])
    args.push('-a', should[:action])
    args.push('-i', should[:interface].join(','))
    args.push('--direction', should[:direction])
    args.push('--quick') if bool_from_value(should[:quick]) == true
    args.push('--no-quick') if bool_from_value(should[:quick]) == false
    args.push('-ip', should[:ipprotocol])
    args.push('-p', should[:protocol])
    args.push('-src', should[:source_net])
    args.push('-src-port', should[:source_port]) unless should[:source_port].empty?
    args.push('--source-not') if bool_from_value(should[:source_not]) == true
    args.push('--no-source-not') if bool_from_value(should[:source_not]) == false
    args.push('-dst', should[:destination_net])
    args.push('-dst-port', should[:destination_port]) unless should[:destination_port].empty?
    args.push('--destination-not') if bool_from_value(should[:destination_not]) == true
    args.push('--no-destination-not') if bool_from_value(should[:destination_not]) == false
    args.push('-g', should[:gateway]) unless should[:gateway].empty?
    args.push('--log') if bool_from_value(should[:log]) == true
    args.push('--no-log') if bool_from_value(should[:log]) == false
    args.push('--enabled') if  bool_from_value(should[:enabled]) == true
    args.push('--disabled') if bool_from_value(should[:enabled]) == false

    args
  end
  #
  private :_get_firewall_rules_from_devices, :_rules_list, :_find_uuid_by_namevars, :_get_command_args
end
