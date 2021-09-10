# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))
require 'puppet/resource_api/simple_provider'

# Implementation for the opnsense_haproxy_server type using the Resource API.
class Puppet::Provider::OpnsenseHaproxyServer::OpnsenseHaproxyServer < Puppet::Provider::OpnsenseProvider
  # writer for testing
  attr_writer :resource_list
  # @return [void]
  def initialize
    super
    @resource_list = []
    @group = 'haproxy'
    @command = 'server'
    @find_uuid_by_column = 'name'
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
    @resource_list = _get_from_devices(device_names)
  end

  # @param [Array<String>] devices
  # @return [Array<Hash<Symbol>>]
  def _get_from_devices(devices)
    result = []
    devices.each do |device|
      servers = get_opn_cli_json_list(device, @group, @command)
      servers.each do |server|
        result.push(
            title: "#{server['name']}@#{device}",
            name: server['name'],
            device: device,
            uuid: server['uuid'],
            enabled: bool_from_value(server['enabled']),
            description: server['description'],
            address: server['address'],
            port: server['port'],
            checkport: server['checkport'],
            mode: server['mode'],
            type: server['type'],
            serviceName: server['serviceName'],
            linkedResolver: server['linkedResolver'],
            resolverOpts: server['resolverOpts'].split(','),
            resolvePrefer: server['resolvePrefer'],
            ssl: bool_from_value(server['ssl']),
            sslVerify: bool_from_value(server['sslVerify']),
            sslCA: server['sslCA'].split(','),
            sslCRL: server['sslCRL'].split(','),
            sslClientCertificate: server['sslClientCertificate'],
            weight: server['weight'],
            checkInterval: server['checkInterval'],
            checkDownInterval: server['checkDownInterval'],
            source: server['source'],
            advanced: server['advanced'],
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
    args = _get_command_args('create', should[:sequence], should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args, '-o', 'json')
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def update(_context, name, should)
    uuid = _find_uuid_by_namevars(name, @find_uuid_by_column)
    args = _get_command_args('update', uuid, should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def delete(_context, name)
    uuid = _find_uuid_by_namevars(name, @find_uuid_by_column)
    device_name = name.fetch(:device).to_s
    opn_cli_base_cmd(device_name, [@group, @command, 'delete', uuid, '-o', 'json'])
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] should
  # @return [Array<String>]
  def _get_command_args(mode, id, should)
    args = [@group, @command, mode, id]
    args.push('--name', should[:name]) if mode == 'update'
    args.push('--enabled') if bool_from_value(should[:enabled]) == true
    args.push('--no-enabled') if bool_from_value(should[:enabled]) == false
    args.push('--description', should[:description])
    args.push('--address', should[:address])
    args.push('--port', should[:port])
    args.push('--checkport', should[:checkport])
    args.push('--mode', should[:mode])
    args.push('--type', should[:type])
    args.push('--serviceName', should[:servicename])
    args.push('--linkedResolver', should[:linkedResolver])
    should[:resolverOpts].each do |opt|
      args.push('--resolverOpts', opt)
    end
    args.push('--resolvePrefer', should[:resolvePrefer])
    args.push('--ssl') if bool_from_value(should[:ssl]) == true
    args.push('--no-ssl') if bool_from_value(should[:ssl]) == false
    args.push('--sslVerify') if bool_from_value(should[:sslVerify]) == true
    args.push('--no-sslVerify') if bool_from_value(should[:sslVerify]) == false
    should[:sslCA].each do |opt|
      args.push('--sslCA', opt)
    end
    should[:sslCRL].each do |opt|
      args.push('--sslCRL', opt)
    end
    args.push('--sslClientCertificate', should[:sslClientCertificate])
    args.push('--weight', should[:weight])
    args.push('--checkInterval', should[:checkInterval])
    args.push('--checkDownInterval', should[:checkDownInterval])
    args.push('--source', should[:source])
    args.push('--advanced', should[:advanced])

    args
  end
  #
  private :_get_from_devices, :_get_command_args
end
