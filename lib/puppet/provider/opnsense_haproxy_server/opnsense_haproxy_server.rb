# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_haproxy_server type using the Resource API.
class Puppet::Provider::OpnsenseHaproxyServer::OpnsenseHaproxyServer < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
    super
    @group = 'haproxy'
    @command = 'server'
    @find_uuid_by_column = 'name'
    @create_key = :name
  end

  # @param [String] device
  # @param [Hash] json_list_item
  def _translate_json_list_item_to_puppet_resource(device, json_list_item)
    {
      title: "#{json_list_item['name']}@#{device}",
      name: json_list_item['name'],
      device: device,
      uuid: json_list_item['uuid'],
      enabled: bool_from_value(json_list_item['enabled']),
      description: json_list_item['description'],
      address: json_list_item['address'],
      port: json_list_item['port'],
      checkport: json_list_item['checkport'],
      mode: json_list_item['mode'],
      type: json_list_item['type'],
      service_name: json_list_item['serviceName'],
      linked_resolver: json_list_item['linkedResolver'],
      resolver_opts: json_list_item['resolverOpts'].split(','),
      resolve_prefer: json_list_item['resolvePrefer'],
      ssl: bool_from_value(json_list_item['ssl']),
      ssl_verify: bool_from_value(json_list_item['sslVerify']),
      ssl_ca: json_list_item['sslCA'].split(','),
      ssl_crl: json_list_item['sslCRL'].split(','),
      ssl_client_certificate: json_list_item['sslClientCertificate'],
      weight: json_list_item['weight'],
      check_interval: json_list_item['checkInterval'],
      check_down_interval: json_list_item['checkDownInterval'],
      source: json_list_item['source'],
      advanced: json_list_item['advanced'],
      ensure: 'present',
    }
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] should
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
  private :_translate_json_list_item_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
