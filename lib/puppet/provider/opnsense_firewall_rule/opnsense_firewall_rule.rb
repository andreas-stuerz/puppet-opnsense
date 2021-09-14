# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_firewall_rule type using the Resource API.
class Puppet::Provider::OpnsenseFirewallRule::OpnsenseFirewallRule < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
    super
    @group = 'firewall'
    @command = 'rule'
    @find_uuid_by_column = 'description'
    @create_key = :sequence
  end

  # @param [String] device
  # @param [Hash] json_list_item
  def _translate_json_list_item_to_puppet_resource(device, json_list_item)
    {
      title: "#{json_list_item['description']}@#{device}",
      sequence: json_list_item['sequence'],
      description: json_list_item['description'],
      device: device,
      uuid: json_list_item['uuid'],
      action: json_list_item['action'],
      interface: json_list_item['interface'].split(','),
      direction: json_list_item['direction'],
      quick: bool_from_value(json_list_item['quick']),
      ipprotocol: json_list_item['ipprotocol'],
      protocol: json_list_item['protocol'],
      source_net: json_list_item['source_net'],
      source_port: json_list_item['source_port'],
      source_not:  bool_from_value(json_list_item['source_not']),
      destination_net: json_list_item['destination_net'],
      destination_port: json_list_item['destination_port'],
      destination_not:  bool_from_value(json_list_item['destination_not']),
      gateway: json_list_item['gateway'],
      log:  bool_from_value(json_list_item['log']),
      enabled:  bool_from_value(json_list_item['enabled']),
      ensure: 'present',
    }
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] puppet_resource
  # @return [Array<String>]
  def _translate_puppet_resource_to_command_args(mode, id, puppet_resource)
    args = [@group, @command, mode, id]
    args.push('-s', puppet_resource[:sequence]) if mode == 'update'
    args.push('--description', puppet_resource[:description])
    args.push('-a', puppet_resource[:action])
    args.push('-i', puppet_resource[:interface].join(','))
    args.push('--direction', puppet_resource[:direction])
    args.push('--quick') if bool_from_value(puppet_resource[:quick]) == true
    args.push('--no-quick') if bool_from_value(puppet_resource[:quick]) == false
    args.push('-ip', puppet_resource[:ipprotocol])
    args.push('-p', puppet_resource[:protocol])
    args.push('-src', puppet_resource[:source_net])
    args.push('-src-port', puppet_resource[:source_port]) unless puppet_resource[:source_port].empty?
    args.push('--source-not') if bool_from_value(puppet_resource[:source_not]) == true
    args.push('--no-source-not') if bool_from_value(puppet_resource[:source_not]) == false
    args.push('-dst', puppet_resource[:destination_net])
    args.push('-dst-port', puppet_resource[:destination_port]) unless puppet_resource[:destination_port].empty?
    args.push('--destination-not') if bool_from_value(puppet_resource[:destination_not]) == true
    args.push('--no-destination-not') if bool_from_value(puppet_resource[:destination_not]) == false
    args.push('-g', puppet_resource[:gateway]) unless puppet_resource[:gateway].empty?
    args.push('--log') if bool_from_value(puppet_resource[:log]) == true
    args.push('--no-log') if bool_from_value(puppet_resource[:log]) == false
    args.push('--enabled') if  bool_from_value(puppet_resource[:enabled]) == true
    args.push('--disabled') if bool_from_value(puppet_resource[:enabled]) == false

    args
  end
  #
  private :_translate_json_list_item_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
