# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_haproxy_frontend type using the Resource API.
class Puppet::Provider::OpnsenseSyslogDestination::OpnsenseSyslogDestination < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
    super
    @group = 'syslog'
    @command = 'destination'
    @resource_type = 'list'
    @find_uuid_by_column = :description
    @create_key = :description
  end

  # @param [String] device
  # @param [Hash] json_object
  def _translate_json_object_to_puppet_resource(device, json_object)
    {
      title: "#{json_object['description']}@#{device}",
      device: device,
      uuid: json_object['uuid'],
      enabled: bool_from_value(json_object['enabled']),
      transport: json_object['transport'],
      program: json_object['program'],
      level: array_from_value(json_object['level']),
      facility: array_from_value(json_object['facility']),
      hostname: json_object['hostname'],
      certificate: json_object['certificate'],
      port: json_object['port'],
      rfc5424: bool_from_value(json_object['rfc5424']),
      description: json_object['description'],
      ensure: 'present',
    }
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] puppet_resource
  # @return [Array<String>]
  def _translate_puppet_resource_to_command_args(mode, id, puppet_resource)
    args = mode == 'create' ? [@group, @command, mode] : [@group, @command, mode, id]

    args.push('--description', puppet_resource[:description])
    args.push('--enabled') if bool_from_value(puppet_resource[:enabled]) == true
    args.push('--no-enabled') if bool_from_value(puppet_resource[:enabled]) == false
    args.push('--transport', puppet_resource[:transport])
    args.push('--program', puppet_resource[:program])
    puppet_resource[:level].each do |opt|
      args.push('--level', opt)
    end
    puppet_resource[:facility].each do |opt|
      args.push('--facility', opt)
    end
    args.push('--hostname', puppet_resource[:hostname])
    args.push('--certificate', puppet_resource[:certificate])
    args.push('--port', puppet_resource[:port])
    args.push('--rfc5424') if bool_from_value(puppet_resource[:rfc5424]) == true
    args.push('--no-rfc5424') if bool_from_value(puppet_resource[:rfc5424]) == false

    args
  end
  #
  private :_translate_json_object_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
