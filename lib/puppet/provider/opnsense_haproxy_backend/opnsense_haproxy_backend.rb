# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_haproxy_backend type using the Resource API.
class Puppet::Provider::OpnsenseHaproxyBackend::OpnsenseHaproxyBackend  < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
      super
      @group = 'haproxy'
      @command = 'backend'
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
      enabled: bool_from_value(json_list_item['enabled']),
      description: json_list_item['description'],
      mode: json_list_item['mode'],
      algorithm: json_list_item['algorithm'],
      random_draws: json_list_item['random_draws'],
      proxy_protocol: json_list_item['proxyProtocol'],
      linked_servers: json_list_item['linkedServers'],
      linked_resolver: json_list_item['linkedResolver'],
      resolver_opts: json_list_item['resolverOpts'],
      resolve_prefer: json_list_item['resolvePrefer'],
      source: json_list_item['source'],
      health_check_enabled: bool_from_value(json_list_item['healthCheckEnabled']),
      health_check: json_list_item['healthCheck'],
      health_check_log_status: bool_from_value(json_list_item['healthCheckLogStatus']),
      check_interval: json_list_item['checkInterval'],
      check_down_interval: json_list_item['checkDownInterval'],
      health_check_fall: json_list_item['healthCheckFall'],
      health_check_rise: json_list_item['healthCheckRise'],
      linked_mailer: json_list_item['linkedMailer'],
      http2_enabled: bool_from_value(json_list_item['http2Enabled']),
      http2_enabled_nontls: bool_from_value(json_list_item['http2Enabled_nontls']),
      ba_advertised_protocols: json_list_item['ba_advertised_protocols'],
      persistence: json_list_item['persistence'],
      persistence_cookiemode: json_list_item['persistence_cookiemode'],
      persistence_cookiename: json_list_item['persistence_cookiename'],
      persistence_stripquotes: bool_from_value(json_list_item['persistence_stripquotes']),
      stickiness_pattern: json_list_item['stickiness_pattern'],
      stickiness_data_types: json_list_item['stickiness_dataTypes'],
      stickiness_expire: json_list_item['stickiness_expire'],
      stickiness_size: json_list_item['stickiness_size'],
      stickiness_cookiename: json_list_item['stickiness_cookiename'],
      stickiness_cookielength: json_list_item['stickiness_cookielength'],
      stickiness_conn_rate_period: json_list_item['stickiness_connRatePeriod'],
      stickiness_sess_rate_period: json_list_item['stickiness_sessRatePeriod'],
      stickiness_http_req_rate_period: json_list_item['stickiness_httpReqRatePeriod'],
      stickiness_http_err_rate_period: json_list_item['stickiness_httpErrRatePeriod'],
      stickiness_bytes_in_rate_period: json_list_item['stickiness_bytesInRatePeriod'],
      stickiness_bytes_out_rate_period: json_list_item['stickiness_bytesOutRatePeriod'],
      basic_auth_enabled: bool_from_value(json_list_item['basicAuthEnabled']),
      basic_auth_users: json_list_item['basicAuthUsers'],
      basic_auth_groups: json_list_item['basicAuthGroups'],
      tuning_timeout_connect: json_list_item['tuning_timeoutConnect'],
      tuning_timeout_check: json_list_item['tuning_timeoutCheck'],
      tuning_timeout_server: json_list_item['tuning_timeoutServer'],
      tuning_retries: json_list_item['tuning_retries'],
      custom_options: json_list_item['customOptions'],
      tuning_defaultserver: json_list_item['tuning_defaultserver'],
      tuning_noport: bool_from_value(json_list_item['tuning_noport']),
      tuning_httpreuse: json_list_item['tuning_httpreuse'],
      tuning_caching: bool_from_value(json_list_item['tuning_caching']),
      linked_actions: json_list_item['linkedActions'],
      linked_errorfiles: json_list_item['linkedErrorfiles'],
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

