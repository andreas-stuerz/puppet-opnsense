# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_haproxy_frontend type using the Resource API.
class Puppet::Provider::OpnsenseHaproxyFrontend::OpnsenseHaproxyFrontend < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
    super
    @group = 'haproxy'
    @command = 'frontend'
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
      bind: json_object['bind'],
      bind_options: json_object['bindOptions'],
      mode: json_object['mode'],
      default_backend: json_object['Backend'],
      ssl_enabled: bool_from_value(json_object['ssl_enabled']),
      ssl_certificates: array_from_value(json_object['ssl_certificates']),
      ssl_default_certificate: json_object['ssl_default_certificate'],
      ssl_custom_options: json_object['ssl_customOptions'],
      ssl_advanced_enabled: bool_from_value(json_object['ssl_advancedEnabled']),
      ssl_bind_options: array_from_value(json_object['ssl_bindOptions']),
      ssl_min_version: json_object['ssl_minVersion'],
      ssl_max_version: json_object['ssl_maxVersion'],
      ssl_cipher_list: json_object['ssl_cipherList'],
      ssl_cipher_suites: json_object['ssl_cipherSuites'],
      ssl_hsts_enabled: bool_from_value(json_object['ssl_hstsEnabled']),
      ssl_hsts_include_sub_domains: bool_from_value(json_object['ssl_hstsIncludeSubDomains']),
      ssl_hsts_preload: bool_from_value(json_object['ssl_hstsPreload']),
      ssl_hsts_max_age: json_object['ssl_hstsMaxAge'],
      ssl_client_auth_enabled: bool_from_value(json_object['ssl_clientAuthEnabled']),
      ssl_client_auth_verify: json_object['ssl_clientAuthVerify'],
      ssl_client_auth_cas: array_from_value(json_object['ssl_clientAuthCAs']),
      ssl_client_auth_crls: array_from_value(json_object['ssl_clientAuthCRLs']),
      basic_auth_enabled: bool_from_value(json_object['basicAuthEnabled']),
      basic_auth_users: array_from_value(json_object['Users']),
      basic_auth_groups: array_from_value(json_object['Groups']),
      tuning_max_connections: json_object['tuning_maxConnections'],
      tuning_timeout_client: json_object['tuning_timeoutClient'],
      tuning_timeout_http_req: json_object['tuning_timeoutHttpReq'],
      tuning_timeout_http_keep_alive: json_object['tuning_timeoutHttpKeepAlive'],
      linked_cpu_affinity_rules: array_from_value(json_object['Cpus']),
      logging_dont_log_null: bool_from_value(json_object['logging_dontLogNull']),
      logging_dont_log_normal: bool_from_value(json_object['logging_dontLogNormal']),
      logging_log_separate_errors: bool_from_value(json_object['logging_logSeparateErrors']),
      logging_detailed_log: bool_from_value(json_object['logging_detailedLog']),
      logging_socket_stats: bool_from_value(json_object['logging_socketStats']),
      stickiness_pattern: json_object['stickiness_pattern'],
      stickiness_data_types: array_from_value(json_object['stickiness_dataTypes']),
      stickiness_expire: json_object['stickiness_expire'],
      stickiness_size: json_object['stickiness_size'],
      stickiness_counter: bool_from_value(json_object['stickiness_counter']),
      stickiness_counter_key: json_object['stickiness_counter_key'],
      stickiness_length: json_object['stickiness_length'],
      stickiness_conn_rate_period: json_object['stickiness_connRatePeriod'],
      stickiness_sess_rate_period: json_object['stickiness_sessRatePeriod'],
      stickiness_http_req_rate_period: json_object['stickiness_httpReqRatePeriod'],
      stickiness_http_err_rate_period: json_object['stickiness_httpErrRatePeriod'],
      stickiness_bytes_in_rate_period: json_object['stickiness_bytesInRatePeriod'],
      stickiness_bytes_out_rate_period: json_object['stickiness_bytesOutRatePeriod'],
      http2_enabled: bool_from_value(json_object['http2Enabled']),
      http2_enabled_nontls: bool_from_value(json_object['http2Enabled_nontls']),
      advertised_protocols: array_from_value(json_object['advertised_protocols']),
      forward_for: bool_from_value(json_object['forwardFor']),
      connection_behaviour: json_object['connectionBehaviour'],
      custom_options: json_object['customOptions'],
      linked_actions: array_from_value(json_object['Actions']),
      linked_errorfiles: array_from_value(json_object['Errorfiles']),
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
    args.push('--bind', puppet_resource[:bind])
    args.push('--bindOptions', puppet_resource[:bind_options])
    args.push('--mode', puppet_resource[:mode])
    args.push('--defaultBackend', puppet_resource[:default_backend])
    args.push('--ssl_enabled') if bool_from_value(puppet_resource[:ssl_enabled]) == true
    args.push('--no-ssl_enabled') if bool_from_value(puppet_resource[:ssl_enabled]) == false
    args.push('--ssl_certificates', puppet_resource[:ssl_certificates].join(','))
    args.push('--ssl_default_certificate', puppet_resource[:ssl_default_certificate])
    args.push('--ssl_customOptions', puppet_resource[:ssl_custom_options])
    args.push('--ssl_advancedEnabled') if bool_from_value(puppet_resource[:ssl_advanced_enabled]) == true
    args.push('--no-ssl_advancedEnabled') if bool_from_value(puppet_resource[:ssl_advanced_enabled]) == false
    puppet_resource[:ssl_bind_options].each do |opt|
      args.push('--ssl_bindOptions', opt)
    end
    args.push('--ssl_minVersion', puppet_resource[:ssl_min_version])
    args.push('--ssl_maxVersion', puppet_resource[:ssl_max_version])
    args.push('--ssl_cipherList', puppet_resource[:ssl_cipher_list])
    args.push('--ssl_cipherSuites', puppet_resource[:ssl_cipher_suites])
    args.push('--ssl_hstsEnabled') if bool_from_value(puppet_resource[:ssl_hsts_enabled]) == true
    args.push('--no-ssl_hstsEnabled') if bool_from_value(puppet_resource[:ssl_hsts_enabled]) == false
    args.push('--ssl_hstsIncludeSubDomains') if bool_from_value(puppet_resource[:ssl_hsts_include_sub_domains]) == true
    args.push('--no-ssl_hstsIncludeSubDomains') if bool_from_value(puppet_resource[:ssl_hsts_include_sub_domains]) == false
    args.push('--ssl_hstsPreload') if bool_from_value(puppet_resource[:ssl_hsts_preload]) == true
    args.push('--no-ssl_hstsPreload') if bool_from_value(puppet_resource[:ssl_hsts_preload]) == false
    args.push('--ssl_hstsMaxAge', puppet_resource[:ssl_hsts_max_age])
    args.push('--ssl_clientAuthEnabled') if bool_from_value(puppet_resource[:ssl_client_auth_enabled]) == true
    args.push('--no-ssl_clientAuthEnabled') if bool_from_value(puppet_resource[:ssl_client_auth_enabled]) == false
    args.push('--ssl_clientAuthVerify', puppet_resource[:ssl_client_auth_verify])
    args.push('--ssl_clientAuthCAs', puppet_resource[:ssl_client_auth_cas].join(','))
    args.push('--ssl_clientAuthCRLs', puppet_resource[:ssl_client_auth_crls].join(','))
    args.push('--basicAuthEnabled') if bool_from_value(puppet_resource[:basic_auth_enabled]) == true
    args.push('--no-basicAuthEnabled') if bool_from_value(puppet_resource[:basic_auth_enabled]) == false
    args.push('--basicAuthUsers', puppet_resource[:basic_auth_users].join(','))
    args.push('--basicAuthGroups', puppet_resource[:basic_auth_groups].join(','))
    args.push('--tuning_maxConnections', puppet_resource[:tuning_max_connections])
    args.push('--tuning_timeoutClient', puppet_resource[:tuning_timeout_client])
    args.push('--tuning_timeoutHttpReq', puppet_resource[:tuning_timeout_http_req])
    args.push('--tuning_timeoutHttpKeepAlive', puppet_resource[:tuning_timeout_http_keep_alive])
    args.push('--linkedCpuAffinityRules', puppet_resource[:linked_cpu_affinity_rules].join(','))
    args.push('--logging_dontLogNull') if bool_from_value(puppet_resource[:logging_dont_log_null]) == true
    args.push('--no-logging_dontLogNull') if bool_from_value(puppet_resource[:logging_dont_log_null]) == false
    args.push('--logging_dontLogNormal') if bool_from_value(puppet_resource[:logging_dont_log_normal]) == true
    args.push('--no-logging_dontLogNormal') if bool_from_value(puppet_resource[:logging_dont_log_normal]) == false
    args.push('--logging_logSeparateErrors') if bool_from_value(puppet_resource[:logging_log_separate_errors]) == true
    args.push('--no-logging_logSeparateErrors') if bool_from_value(puppet_resource[:logging_log_separate_errors]) == false
    args.push('--logging_detailedLog') if bool_from_value(puppet_resource[:logging_detailed_log]) == true
    args.push('--no-logging_detailedLog') if bool_from_value(puppet_resource[:logging_detailed_log]) == false
    args.push('--logging_socketStats') if bool_from_value(puppet_resource[:logging_socket_stats]) == true
    args.push('--no-logging_socketStats') if bool_from_value(puppet_resource[:logging_socket_stats]) == false
    args.push('--stickiness_pattern', puppet_resource[:stickiness_pattern])
    puppet_resource[:stickiness_data_types].each do |opt|
      args.push('--stickiness_dataTypes', opt)
    end
    args.push('--stickiness_expire', puppet_resource[:stickiness_expire])
    args.push('--stickiness_size', puppet_resource[:stickiness_size])
    args.push('--stickiness_counter') if bool_from_value(puppet_resource[:stickiness_counter]) == true
    args.push('--no-stickiness_counter') if bool_from_value(puppet_resource[:stickiness_counter]) == false
    args.push('--stickiness_counter_key', puppet_resource[:stickiness_counter_key])
    args.push('--stickiness_length', puppet_resource[:stickiness_length])
    args.push('--stickiness_connRatePeriod', puppet_resource[:stickiness_conn_rate_period])
    args.push('--stickiness_sessRatePeriod', puppet_resource[:stickiness_sess_rate_period])
    args.push('--stickiness_httpReqRatePeriod', puppet_resource[:stickiness_http_req_rate_period])
    args.push('--stickiness_sessRatePeriod', puppet_resource[:stickiness_sess_rate_period])
    args.push('--stickiness_httpReqRatePeriod', puppet_resource[:stickiness_http_req_rate_period])
    args.push('--stickiness_httpErrRatePeriod', puppet_resource[:stickiness_http_err_rate_period])
    args.push('--stickiness_bytesInRatePeriod', puppet_resource[:stickiness_bytes_in_rate_period])
    args.push('--stickiness_bytesOutRatePeriod', puppet_resource[:stickiness_bytes_out_rate_period])
    args.push('--http2Enabled') if bool_from_value(puppet_resource[:http2_enabled]) == true
    args.push('--no-http2Enabled') if bool_from_value(puppet_resource[:http2_enabled]) == false
    args.push('--http2Enabled_nontls') if bool_from_value(puppet_resource[:http2_enabled_nontls]) == true
    args.push('--no-http2Enabled_nontls') if bool_from_value(puppet_resource[:http2_enabled_nontls]) == false
    puppet_resource[:advertised_protocols].each do |opt|
      args.push('--advertised_protocols', opt)
    end
    args.push('--forwardFor') if bool_from_value(puppet_resource[:forward_for]) == true
    args.push('--no-forwardFor') if bool_from_value(puppet_resource[:forward_for]) == false
    args.push('--connectionBehaviour', puppet_resource[:connection_behaviour])
    args.push('--customOptions', puppet_resource[:custom_options])
    args.push('--linkedActions', puppet_resource[:linked_actions].join(','))
    args.push('--linkedErrorfiles', puppet_resource[:linked_errorfiles].join(','))
    args
  end
  #
  private :_translate_json_object_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
