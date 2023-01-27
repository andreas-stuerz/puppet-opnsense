# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_haproxy_server type using the Resource API.
class Puppet::Provider::OpnsenseHaproxyServer::OpnsenseHaproxyServer < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
    super
    @group = 'haproxy'
    @command = 'server'
    @resource_type = 'list'
    @find_uuid_by_column = :name
    @create_key = :name
  end

  # @param [String] device
  # @param [Hash] json_object
  def _translate_json_object_to_puppet_resource(device, json_object)
    {
      title: "#{json_object['name']}@#{device}",
      name: json_object['name'],
      device: device,
      uuid: json_object['uuid'],
      enabled: bool_from_value(json_object['enabled']),
      description: json_object['description'],
      address: json_object['address'],
      port: json_object['port'],
      checkport: json_object['checkport'],
      mode: json_object['mode'],
      type: json_object['type'],
      service_name: json_object['serviceName'],
      linked_resolver: json_object['Resolver'],
      resolver_opts: json_object['resolverOpts'].split(','),
      resolve_prefer: json_object['resolvePrefer'],
      ssl: bool_from_value(json_object['ssl']),
      ssl_verify: bool_from_value(json_object['sslVerify']),
      ssl_ca: json_object['sslCA'].split(','),
      ssl_crl: json_object['sslCRL'].split(','),
      ssl_client_certificate: json_object['sslClientCertificate'],
      weight: json_object['weight'],
      check_interval: json_object['checkInterval'],
      check_down_interval: json_object['checkDownInterval'],
      source: json_object['source'],
      advanced: json_object['advanced'],
      ensure: 'present',
    }
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] puppet_resource
  # @return [Array<String>]
  def _translate_puppet_resource_to_command_args(mode, id, puppet_resource)
    args = [@group, @command, mode, id]
    args.push('--name', puppet_resource[:name]) if mode == 'update'
    args.push('--enabled') if bool_from_value(puppet_resource[:enabled]) == true
    args.push('--no-enabled') if bool_from_value(puppet_resource[:enabled]) == false
    args.push('--description', puppet_resource[:description])
    args.push('--address', puppet_resource[:address])
    args.push('--port', puppet_resource[:port])
    args.push('--checkport', puppet_resource[:checkport])
    args.push('--mode', puppet_resource[:mode])
    args.push('--type', puppet_resource[:type])
    args.push('--serviceName', puppet_resource[:service_name])
    args.push('--linkedResolver', puppet_resource[:linked_resolver])
    puppet_resource[:resolver_opts].each do |opt|
      args.push('--resolverOpts', opt)
    end
    args.push('--resolvePrefer', puppet_resource[:resolve_prefer])
    args.push('--ssl') if bool_from_value(puppet_resource[:ssl]) == true
    args.push('--no-ssl') if bool_from_value(puppet_resource[:ssl]) == false
    args.push('--sslVerify') if bool_from_value(puppet_resource[:ssl_verify]) == true
    args.push('--no-sslVerify') if bool_from_value(puppet_resource[:ssl_verify]) == false
    puppet_resource[:ssl_ca].each do |opt|
      args.push('--sslCA', opt)
    end
    puppet_resource[:ssl_crl].each do |opt|
      args.push('--sslCRL', opt)
    end
    args.push('--sslClientCertificate', puppet_resource[:ssl_client_certificate])
    args.push('--weight', puppet_resource[:weight])
    args.push('--checkInterval', puppet_resource[:check_interval])
    args.push('--checkDownInterval', puppet_resource[:check_down_interval])
    args.push('--source', puppet_resource[:source])
    args.push('--advanced', puppet_resource[:advanced])

    args
  end
  #
  private :_translate_json_object_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
