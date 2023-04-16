# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_haproxy_frontend type using the Resource API.
class Puppet::Provider::OpnsenseRouteStatic::OpnsenseRouteStatic < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
    super
    @group = 'route'
    @command = 'static'
    @resource_type = 'list'
    @find_uuid_by_column = :descr
    @create_key = :descr
  end

  # @param [String] device
  # @param [Hash] json_object
  def _translate_json_object_to_puppet_resource(device, json_object)
    {
      title: "#{json_object['descr']}@#{device}",
      device: device,
      uuid: json_object['uuid'],
      network: json_object['network'],
      gateway: json_object['gateway'],
      descr: json_object['descr'],
      disabled: bool_from_value(json_object['disabled']),

      ensure: 'present',
    }
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] puppet_resource
  # @return [Array<String>]
  def _translate_puppet_resource_to_command_args(mode, id, puppet_resource)
    args = mode == 'create' ? [@group, @command, mode] : [@group, @command, mode, id]

    args.push('--network', puppet_resource[:network])
    args.push('--gateway', puppet_resource[:gateway])
    args.push('--descr', puppet_resource[:descr])
    args.push('--disabled') if bool_from_value(puppet_resource[:disabled]) == true
    args.push('--no-disabled') if bool_from_value(puppet_resource[:disabled]) == false

    args
  end
  #
  private :_translate_json_object_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
