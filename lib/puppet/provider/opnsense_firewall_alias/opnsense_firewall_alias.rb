# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_firewall_alias type using the Resource API.
class Puppet::Provider::OpnsenseFirewallAlias::OpnsenseFirewallAlias < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
    super
    @group = 'firewall'
    @command = 'alias'
    @find_uuid_by_column = :name
    @create_key = :name
  end

  # @param [String] device
  # @param [Hash] json_list_item
  def _translate_json_list_item_to_puppet_resource(device, json_list_item)
    {
      title: json_list_item['name'] + '@' + device,
      name: json_list_item['name'],
      device: device,
      type: json_list_item['type'],
      description: json_list_item['description'],
      content: json_list_item['content'].split(','),
      proto: json_list_item['proto'],
      updatefreq: json_list_item['updatefreq'].nil? ? '' : json_list_item['updatefreq'].to_f,
      counters: bool_from_value(json_list_item['counters']),
      enabled: bool_from_value(json_list_item['enabled']),
      ensure: 'present',
    }
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] puppet_resource
  # @return [Array<String>]
  def _translate_puppet_resource_to_command_args(mode, id, puppet_resource)
    args = ['firewall', 'alias', mode, id]
    args.push('-t', puppet_resource[:type])
    args.push('-d', puppet_resource[:description])
    args.push('-C', puppet_resource[:content].join(','))
    args.push('-p', puppet_resource[:proto]) if puppet_resource[:proto]
    args.push('-u', puppet_resource[:updatefreq].to_f) if puppet_resource[:updatefreq]
    args.push('--counters') if bool_from_value(puppet_resource[:counters]) == true
    args.push('--no-counters') if bool_from_value(puppet_resource[:counters]) == false
    args.push('--enabled') if  bool_from_value(puppet_resource[:enabled]) == true
    args.push('--disabled') if bool_from_value(puppet_resource[:enabled]) == false

    args
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def create(_context, _name, should)
    args = _translate_puppet_resource_to_command_args('create', should[:name], should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def update(_context, _name, should)
    args = _translate_puppet_resource_to_command_args('update', should[:name], should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def delete(_context, name)
    alias_name = name.fetch(:name).to_s
    device_name = name.fetch(:device).to_s
    opn_cli_base_cmd(device_name, [@group, @command, 'delete', alias_name, '-o', 'json'])
  end
  #
  private :_translate_json_list_item_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
