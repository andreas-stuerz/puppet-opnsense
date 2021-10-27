# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_haproxy_backend type using the Resource API.
class Puppet::Provider::OpnsenseHaproxyBackend::OpnsenseHaproxyBackend < Puppet::Provider::OpnsenseProvider
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
      uuid: json_list_item['uuid'],
      enabled: bool_from_value(json_list_item['enabled']),
      description: json_list_item['description'],
      mode: json_list_item['mode'],
      algorithm: json_list_item['algorithm'],
      random_draws: json_list_item['random_draws'],
      proxy_protocol: json_list_item['proxyProtocol'],
      linked_servers: array_from_value(json_list_item['Servers']),
      linked_resolver: json_list_item['Resolver'],
      resolver_opts: json_list_item['resolverOpts'].split(','),
      resolve_prefer: json_list_item['resolvePrefer'],
      source: json_list_item['source'],
      health_check_enabled: bool_from_value(json_list_item['healthCheckEnabled']),
      health_check: json_list_item['Healthcheck'],
      health_check_log_status: bool_from_value(json_list_item['healthCheckLogStatus']),
      check_interval: json_list_item['checkInterval'],
      check_down_interval: json_list_item['checkDownInterval'],
      health_check_fall: json_list_item['healthCheckFall'],
      health_check_rise: json_list_item['healthCheckRise'],
      linked_mailer: json_list_item['Mailer'],
      http2_enabled: bool_from_value(json_list_item['http2Enabled']),
      http2_enabled_nontls: bool_from_value(json_list_item['http2Enabled_nontls']),
      ba_advertised_protocols: json_list_item['ba_advertised_protocols'].split(','),
      persistence: json_list_item['persistence'],
      persistence_cookiemode: json_list_item['persistence_cookiemode'],
      persistence_cookiename: json_list_item['persistence_cookiename'],
      persistence_stripquotes: bool_from_value(json_list_item['persistence_stripquotes']),
      stickiness_pattern: json_list_item['stickiness_pattern'],
      stickiness_data_types: json_list_item['stickiness_dataTypes'].split(','),
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
      basic_auth_users: array_from_value(json_list_item['Users']),
      basic_auth_groups: array_from_value(json_list_item['Groups']),
      tuning_timeout_connect: json_list_item['tuning_timeoutConnect'],
      tuning_timeout_check: json_list_item['tuning_timeoutCheck'],
      tuning_timeout_server: json_list_item['tuning_timeoutServer'],
      tuning_retries: json_list_item['tuning_retries'],
      custom_options: json_list_item['customOptions'],
      tuning_defaultserver: json_list_item['tuning_defaultserver'],
      tuning_noport: bool_from_value(json_list_item['tuning_noport']),
      tuning_httpreuse: json_list_item['tuning_httpreuse'],
      tuning_caching: bool_from_value(json_list_item['tuning_caching']),
      linked_actions: array_from_value(json_list_item['Actions']),
      linked_errorfiles: array_from_value(json_list_item['Errorfiles']),
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
    args.push('--mode', puppet_resource[:mode])
    args.push('--algorithm', puppet_resource[:algorithm])
    args.push('--random_draws', puppet_resource[:random_draws])
    args.push('--proxyProtocol', puppet_resource[:proxy_protocol])
    args.push('--linkedServers', puppet_resource[:linked_servers].join(','))
    args.push('--linkedResolver', puppet_resource[:linked_resolver])
    puppet_resource[:resolver_opts].each do |opt|
      args.push('--resolverOpts', opt)
    end
    args.push('--resolvePrefer', puppet_resource[:resolve_prefer])
    args.push('--source', puppet_resource[:source])
    args.push('--healthCheckEnabled') if bool_from_value(puppet_resource[:health_check_enabled]) == true
    args.push('--no-healthCheckEnabled') if bool_from_value(puppet_resource[:health_check_enabled]) == false
    args.push('--healthCheck', puppet_resource[:health_check])
    args.push('--healthCheckLogStatus') if bool_from_value(puppet_resource[:health_check_log_status]) == true
    args.push('--no-healthCheckLogStatus') if bool_from_value(puppet_resource[:health_check_log_status]) == false
    args.push('--checkInterval', puppet_resource[:check_interval])
    args.push('--checkDownInterval', puppet_resource[:check_down_interval])
    args.push('--healthCheckFall', puppet_resource[:health_check_fall])
    args.push('--healthCheckRise', puppet_resource[:health_check_rise])
    args.push('--linkedMailer', puppet_resource[:linked_mailer])
    args.push('--http2Enabled') if bool_from_value(puppet_resource[:http2_enabled]) == true
    args.push('--no-http2Enabled') if bool_from_value(puppet_resource[:http2_enabled]) == false
    args.push('--http2Enabled_nontls') if bool_from_value(puppet_resource[:http2_enabled_nontls]) == true
    args.push('--no-http2Enabled_nontls') if bool_from_value(puppet_resource[:http2_enabled_nontls]) == false
    puppet_resource[:ba_advertised_protocols].each do |opt|
      args.push('--ba_advertised_protocols', opt)
    end
    args.push('--persistence', puppet_resource[:persistence])
    args.push('--persistence_cookiemode', puppet_resource[:persistence_cookiemode])
    args.push('--persistence_cookiename', puppet_resource[:persistence_cookiename])
    args.push('--persistence_stripquotes') if bool_from_value(puppet_resource[:persistence_stripquotes]) == true
    args.push('--no-persistence_stripquotes') if bool_from_value(puppet_resource[:persistence_stripquotes]) == false
    args.push('--stickiness_pattern', puppet_resource[:stickiness_pattern])
    puppet_resource[:stickiness_data_types].each do |opt|
      args.push('--stickiness_dataTypes', opt)
    end
    args.push('--stickiness_expire', puppet_resource[:stickiness_expire])
    args.push('--stickiness_size', puppet_resource[:stickiness_size])
    args.push('--stickiness_cookiename', puppet_resource[:stickiness_cookiename])
    args.push('--stickiness_cookielength', puppet_resource[:stickiness_cookielength])
    args.push('--stickiness_connRatePeriod', puppet_resource[:stickiness_conn_rate_period])
    args.push('--stickiness_sessRatePeriod', puppet_resource[:stickiness_sess_rate_period])
    args.push('--stickiness_httpReqRatePeriod', puppet_resource[:stickiness_http_req_rate_period])
    args.push('--stickiness_httpErrRatePeriod', puppet_resource[:stickiness_http_err_rate_period])
    args.push('--stickiness_bytesInRatePeriod', puppet_resource[:stickiness_bytes_in_rate_period])
    args.push('--stickiness_bytesOutRatePeriod', puppet_resource[:stickiness_bytes_out_rate_period])
    args.push('--basicAuthEnabled') if bool_from_value(puppet_resource[:basic_auth_enabled]) == true
    args.push('--no-basicAuthEnabled') if bool_from_value(puppet_resource[:basic_auth_enabled]) == false
    args.push('--basicAuthUsers', puppet_resource[:basic_auth_users].join(','))
    args.push('--basicAuthGroups', puppet_resource[:basic_auth_groups].join(','))
    args.push('--tuning_timeoutConnect', puppet_resource[:tuning_timeout_connect])
    args.push('--tuning_timeoutCheck', puppet_resource[:tuning_timeout_check])
    args.push('--tuning_timeoutServer', puppet_resource[:tuning_timeout_server])
    args.push('--tuning_retries', puppet_resource[:tuning_retries])
    args.push('--customOptions', puppet_resource[:custom_options])
    args.push('--tuning_defaultserver', puppet_resource[:tuning_defaultserver])
    args.push('--tuning_noport') if bool_from_value(puppet_resource[:tuning_noport]) == true
    args.push('--no-tuning_noport') if bool_from_value(puppet_resource[:tuning_noport]) == false
    args.push('--tuning_httpreuse', puppet_resource[:tuning_httpreuse])
    args.push('--tuning_caching') if bool_from_value(puppet_resource[:tuning_caching]) == true
    args.push('--no-tuning_caching') if bool_from_value(puppet_resource[:tuning_caching]) == false
    args.push('--linkedActions', puppet_resource[:linked_actions].join(','))
    args.push('--linkedErrorfiles', puppet_resource[:linked_errorfiles].join(','))

    args
  end
  #
  private :_translate_json_list_item_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
