require 'spec_helper_acceptance'

describe 'opnsense_haproxy_frontend' do
  context 'for opnsense-test.device.com' do
    describe 'add webserver_frontend' do
      pp = <<-MANIFEST
      opnsense_haproxy_frontend { 'webserver_frontend':
        device                           => 'opnsense-test.device.com',
        enabled                          => true,
        description                      => 'frontend for webserver',
        bind                             => '127.0.0.1:8080',
        bind_options                     => '',
        mode                             => 'http',
        default_backend                  => '',
        ssl_enabled                      => true,
        ssl_certificates                 => ['60cc4641eb577', '5eba6f0f352e3'],
        ssl_default_certificate          => '60cc4641eb577',
        ssl_custom_options               => '',
        ssl_advanced_enabled             => true,
        ssl_bind_options                 => ['prefer-client-ciphers'],
        ssl_min_version                  => 'TLSv1.2',
        ssl_max_version                  => '',
        ssl_cipher_list                  => 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256',
        ssl_cipher_suites                => 'TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256',
        ssl_hsts_enabled                 => true,
        ssl_hsts_include_sub_domains     => true,
        ssl_hsts_preload                 => true,
        ssl_hsts_max_age                 => '15768000',
        ssl_client_auth_enabled          => true,
        ssl_client_auth_verify           => 'required',
        ssl_client_auth_cas              => [],
        ssl_client_auth_crls             => [],
        basic_auth_enabled               => true,
        basic_auth_users                 => [],
        basic_auth_groups                => [],
        tuning_max_connections           => '',
        tuning_timeout_client            => '',
        tuning_timeout_http_req          => '',
        tuning_timeout_http_keep_alive   => '',
        linked_cpu_affinity_rules        => [],
        logging_dont_log_null            => true,
        logging_dont_log_normal          => true,
        logging_log_separate_errors      => true,
        logging_detailed_log             => true,
        logging_socket_stats             => true,
        stickiness_pattern               => '',
        stickiness_data_types            => [''],
        stickiness_expire                => '30m',
        stickiness_size                  => '50k',
        stickiness_counter               => true,
        stickiness_counter_key           => 'src',
        stickiness_length                => '',
        stickiness_conn_rate_period      => '10s',
        stickiness_sess_rate_period      => '10s',
        stickiness_http_req_rate_period  => '10s',
        stickiness_http_err_rate_period  => '10s',
        stickiness_bytes_in_rate_period  => '1m',
        stickiness_bytes_out_rate_period => '1m',
        http2_enabled                    => true,
        http2_enabled_nontls             => true,
        advertised_protocols             => ['h2', 'http11'],
        forward_for                      => true,
        connection_behaviour             => 'http-keep-alive',
        custom_options                   => '',
        linked_actions                   => [],
        linked_errorfiles                => [],
        ensure                           => 'present',
      }
    MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the created rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'enabled', 'name', 'description', 'bind', 'bindOptions', 'mode', 'defaultBackend', 'ssl_enabled',
          'ssl_certificates', 'ssl_default_certificate', 'ssl_customOptions', 'ssl_advancedEnabled', 'ssl_bindOptions',
          'ssl_minVersion', 'ssl_maxVersion', 'ssl_cipherList', 'ssl_cipherSuites', 'ssl_hstsEnabled',
          'ssl_hstsIncludeSubDomains', 'ssl_hstsPreload', 'ssl_hstsMaxAge', 'ssl_clientAuthEnabled',
          'ssl_clientAuthVerify', 'ssl_clientAuthCAs', 'ssl_clientAuthCRLs', 'basicAuthEnabled', 'basicAuthUsers',
          'basicAuthGroups', 'tuning_maxConnections', 'tuning_timeoutClient', 'tuning_timeoutHttpReq',
          'tuning_timeoutHttpKeepAlive', 'linkedCpuAffinityRules', 'logging_dontLogNull', 'logging_dontLogNormal',
          'logging_logSeparateErrors', 'logging_detailedLog', 'logging_socketStats', 'stickiness_pattern',
          'stickiness_dataTypes', 'stickiness_expire', 'stickiness_size', 'stickiness_counter', 'stickiness_counter_key',
          'stickiness_length', 'stickiness_connRatePeriod', 'stickiness_sessRatePeriod', 'stickiness_httpReqRatePeriod',
          'stickiness_httpErrRatePeriod', 'stickiness_bytesInRatePeriod', 'stickiness_bytesOutRatePeriod',
          'http2Enabled', 'http2Enabled_nontls', 'advertised_protocols', 'forwardFor', 'connectionBehaviour',
          'customOptions', 'linkedActions', 'linkedErrorfiles'
        ].join(',')
        run_shell(build_opn_cli_cmd("haproxy frontend list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{enabled: '1'}
          expect(r.stdout).to match %r{name: webserver_frontend}
          expect(r.stdout).to match %r{description: frontend for webserver}
          expect(r.stdout).to match %r{bind: 127.0.0.1:8080}
          expect(r.stdout).to match %r{bindOptions: ''}
          expect(r.stdout).to match %r{mode: http}
          expect(r.stdout).to match %r{defaultBackend: ''}
          expect(r.stdout).to match %r{ssl_enabled: '1'}
          expect(r.stdout).to match %r{ssl_certificates: 60cc4641eb577,5eba6f0f352e3}
          expect(r.stdout).to match %r{ssl_default_certificate: 60cc4641eb577}
          expect(r.stdout).to match %r{ssl_customOptions: ''}
          expect(r.stdout).to match %r{ssl_advancedEnabled: '1'}
          expect(r.stdout).to match %r{ssl_bindOptions: prefer-client-ciphers}
          expect(r.stdout).to match %r{ssl_minVersion: TLSv1.2}
          expect(r.stdout).to match %r{ssl_maxVersion: ''}
          expect(r.stdout).to match %r{ssl_cipherList: ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384}
          expect(r.stdout).to match %r{ssl_cipherSuites: TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384}
          expect(r.stdout).to match %r{ssl_hstsEnabled: '1'}
          expect(r.stdout).to match %r{ssl_hstsIncludeSubDomains: '1'}
          expect(r.stdout).to match %r{ssl_hstsPreload: '1'}
          expect(r.stdout).to match %r{ssl_hstsMaxAge: '15768000'}
          expect(r.stdout).to match %r{ssl_clientAuthEnabled: '1'}
          expect(r.stdout).to match %r{ssl_clientAuthVerify: required}
          expect(r.stdout).to match %r{ssl_clientAuthCAs: ''}
          expect(r.stdout).to match %r{ssl_clientAuthCRLs: ''}
          expect(r.stdout).to match %r{basicAuthEnabled: '1'}
          expect(r.stdout).to match %r{basicAuthUsers: '\[\]'}
          expect(r.stdout).to match %r{basicAuthGroups: '\[\]'}
          expect(r.stdout).to match %r{tuning_maxConnections: ''}
          expect(r.stdout).to match %r{tuning_timeoutClient: ''}
          expect(r.stdout).to match %r{tuning_timeoutHttpReq: ''}
          expect(r.stdout).to match %r{tuning_timeoutHttpKeepAlive: ''}
          expect(r.stdout).to match %r{linkedCpuAffinityRules: '\[\]'}
          expect(r.stdout).to match %r{logging_dontLogNull: '1'}
          expect(r.stdout).to match %r{logging_dontLogNormal: '1'}
          expect(r.stdout).to match %r{logging_logSeparateErrors: '1'}
          expect(r.stdout).to match %r{logging_detailedLog: '1'}
          expect(r.stdout).to match %r{logging_socketStats: '1'}
          expect(r.stdout).to match %r{stickiness_pattern: ''}
          expect(r.stdout).to match %r{stickiness_dataTypes: ''}
          expect(r.stdout).to match %r{stickiness_expire: 30m}
          expect(r.stdout).to match %r{stickiness_size: 50k}
          expect(r.stdout).to match %r{stickiness_counter: '1'}
          expect(r.stdout).to match %r{stickiness_counter_key: src}
          expect(r.stdout).to match %r{stickiness_length: ''}
          expect(r.stdout).to match %r{stickiness_connRatePeriod: 10s}
          expect(r.stdout).to match %r{stickiness_sessRatePeriod: 10s}
          expect(r.stdout).to match %r{stickiness_httpReqRatePeriod: 10s}
          expect(r.stdout).to match %r{stickiness_httpErrRatePeriod: 10s}
          expect(r.stdout).to match %r{stickiness_bytesInRatePeriod: 1m}
          expect(r.stdout).to match %r{stickiness_bytesOutRatePeriod: 1m}
          expect(r.stdout).to match %r{http2Enabled: '1'}
          expect(r.stdout).to match %r{http2Enabled_nontls: '1'}
          expect(r.stdout).to match %r{advertised_protocols: h2,http11}
          expect(r.stdout).to match %r{forwardFor: '1'}
          expect(r.stdout).to match %r{connectionBehaviour: http-keep-alive}
          expect(r.stdout).to match %r{customOptions: ''}
          expect(r.stdout).to match %r{linkedActions: '\[\]'}
          expect(r.stdout).to match %r{linkedErrorfiles: '\[\]'}
        end
      end
    end

    describe 'update webserver_frontend' do
      pp = <<-MANIFEST
      opnsense_haproxy_frontend { 'webserver_frontend':
        device                           => 'opnsense-test.device.com',
        enabled                          => false,
        description                      => 'frontend for webserver modified',
        bind                             => '127.0.0.1:8081',
        bind_options                     => 'accept-proxy npn http/1.1',
        mode                             => 'ssl',
        default_backend                  => '',
        ssl_enabled                      => false,
        ssl_certificates                 => ['60cc4641eb577'],
        ssl_default_certificate          => '60cc4641eb577',
        ssl_custom_options               => '',
        ssl_advanced_enabled             => false,
        ssl_bind_options                 => ['prefer-client-ciphers', 'force-sslv3'],
        ssl_min_version                  => 'TLSv1.1',
        ssl_max_version                  => '',
        ssl_cipher_list                  => 'ECDHE-ECDSA-AES256-GCM-SHA384',
        ssl_cipher_suites                => 'TLS_AES_128_GCM_SHA256',
        ssl_hsts_enabled                 => false,
        ssl_hsts_include_sub_domains     => false,
        ssl_hsts_preload                 => false,
        ssl_hsts_max_age                 => '15768500',
        ssl_client_auth_enabled          => false,
        ssl_client_auth_verify           => 'optional',
        ssl_client_auth_cas              => [],
        ssl_client_auth_crls             => [],
        basic_auth_enabled               => false,
        basic_auth_users                 => [],
        basic_auth_groups                => [],
        tuning_max_connections           => '50',
        tuning_timeout_client            => '60s',
        tuning_timeout_http_req          => '60s',
        tuning_timeout_http_keep_alive   => '60s',
        linked_cpu_affinity_rules        => [],
        logging_dont_log_null            => false,
        logging_dont_log_normal          => false,
        logging_log_separate_errors      => false,
        logging_detailed_log             => false,
        logging_socket_stats             => false,
        stickiness_pattern               => 'ipv4',
        stickiness_data_types            => ['conn_rate', 'sess_cnt'],
        stickiness_expire                => '40m',
        stickiness_size                  => '40k',
        stickiness_counter               => false,
        stickiness_counter_key           => 'path',
        stickiness_length                => '100',
        stickiness_conn_rate_period      => '20s',
        stickiness_sess_rate_period      => '20s',
        stickiness_http_req_rate_period  => '20s',
        stickiness_http_err_rate_period  => '20s',
        stickiness_bytes_in_rate_period  => '2m',
        stickiness_bytes_out_rate_period => '2m',
        http2_enabled                    => false,
        http2_enabled_nontls             => false,
        advertised_protocols             => ['h2'],
        forward_for                      => false,
        connection_behaviour             => 'http-tunnel',
        custom_options                   => '',
        linked_actions                   => [],
        linked_errorfiles                => [],
        ensure                           => 'present',
      }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the updated rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'enabled', 'name', 'description', 'bind', 'bindOptions', 'mode', 'defaultBackend', 'ssl_enabled',
          'ssl_certificates', 'ssl_default_certificate', 'ssl_customOptions', 'ssl_advancedEnabled', 'ssl_bindOptions',
          'ssl_minVersion', 'ssl_maxVersion', 'ssl_cipherList', 'ssl_cipherSuites', 'ssl_hstsEnabled',
          'ssl_hstsIncludeSubDomains', 'ssl_hstsPreload', 'ssl_hstsMaxAge', 'ssl_clientAuthEnabled',
          'ssl_clientAuthVerify', 'ssl_clientAuthCAs', 'ssl_clientAuthCRLs', 'basicAuthEnabled', 'basicAuthUsers',
          'basicAuthGroups', 'tuning_maxConnections', 'tuning_timeoutClient', 'tuning_timeoutHttpReq',
          'tuning_timeoutHttpKeepAlive', 'linkedCpuAffinityRules', 'logging_dontLogNull', 'logging_dontLogNormal',
          'logging_logSeparateErrors', 'logging_detailedLog', 'logging_socketStats', 'stickiness_pattern',
          'stickiness_dataTypes', 'stickiness_expire', 'stickiness_size', 'stickiness_counter', 'stickiness_counter_key',
          'stickiness_length', 'stickiness_connRatePeriod', 'stickiness_sessRatePeriod', 'stickiness_httpReqRatePeriod',
          'stickiness_httpErrRatePeriod', 'stickiness_bytesInRatePeriod', 'stickiness_bytesOutRatePeriod',
          'http2Enabled', 'http2Enabled_nontls', 'advertised_protocols', 'forwardFor', 'connectionBehaviour',
          'customOptions', 'linkedActions', 'linkedErrorfiles'
        ].join(',')
        run_shell(build_opn_cli_cmd("haproxy frontend list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{enabled: '0'}
          expect(r.stdout).to match %r{name: webserver_frontend}
          expect(r.stdout).to match %r{description: frontend for webserver modified}
          expect(r.stdout).to match %r{bind: 127.0.0.1:8081}
          expect(r.stdout).to match %r{bindOptions: accept-proxy npn http\/1.1}
          expect(r.stdout).to match %r{mode: ssl}
          expect(r.stdout).to match %r{defaultBackend: ''}
          expect(r.stdout).to match %r{ssl_enabled: '0'}
          expect(r.stdout).to match %r{ssl_certificates: 60cc4641eb577}
          expect(r.stdout).to match %r{ssl_default_certificate: 60cc4641eb577}
          expect(r.stdout).to match %r{ssl_customOptions: ''}
          expect(r.stdout).to match %r{ssl_advancedEnabled: '0'}
          expect(r.stdout).to match %r{ssl_bindOptions: force-sslv3,prefer-client-ciphers}
          expect(r.stdout).to match %r{ssl_minVersion: TLSv1.1}
          expect(r.stdout).to match %r{ssl_maxVersion: ''}
          expect(r.stdout).to match %r{ssl_cipherList: ECDHE-ECDSA-AES256-GCM-SHA384}
          expect(r.stdout).to match %r{ssl_cipherSuites: TLS_AES_128_GCM_SHA256}
          expect(r.stdout).to match %r{ssl_hstsEnabled: '0'}
          expect(r.stdout).to match %r{ssl_hstsIncludeSubDomains: '0'}
          expect(r.stdout).to match %r{ssl_hstsPreload: '0'}
          expect(r.stdout).to match %r{ssl_hstsMaxAge: '15768500'}
          expect(r.stdout).to match %r{ssl_clientAuthEnabled: '0'}
          expect(r.stdout).to match %r{ssl_clientAuthVerify: optional}
          expect(r.stdout).to match %r{ssl_clientAuthCAs: ''}
          expect(r.stdout).to match %r{ssl_clientAuthCRLs: ''}
          expect(r.stdout).to match %r{basicAuthEnabled: '0'}
          expect(r.stdout).to match %r{basicAuthUsers: '\[\]'}
          expect(r.stdout).to match %r{basicAuthGroups: '\[\]'}
          expect(r.stdout).to match %r{tuning_maxConnections: '50'}
          expect(r.stdout).to match %r{tuning_timeoutClient: 60s}
          expect(r.stdout).to match %r{tuning_timeoutHttpReq: 60s}
          expect(r.stdout).to match %r{tuning_timeoutHttpKeepAlive: 60s}
          expect(r.stdout).to match %r{linkedCpuAffinityRules: '\[\]'}
          expect(r.stdout).to match %r{logging_dontLogNull: '0'}
          expect(r.stdout).to match %r{logging_dontLogNormal: '0'}
          expect(r.stdout).to match %r{logging_logSeparateErrors: '0'}
          expect(r.stdout).to match %r{logging_detailedLog: '0'}
          expect(r.stdout).to match %r{logging_socketStats: '0'}
          expect(r.stdout).to match %r{stickiness_pattern: ipv4}
          expect(r.stdout).to match %r{stickiness_dataTypes: conn_rate,sess_cnt}
          expect(r.stdout).to match %r{stickiness_expire: 40m}
          expect(r.stdout).to match %r{stickiness_size: 40k}
          expect(r.stdout).to match %r{stickiness_counter: '0'}
          expect(r.stdout).to match %r{stickiness_counter_key: path}
          expect(r.stdout).to match %r{stickiness_length: '100'}
          expect(r.stdout).to match %r{stickiness_connRatePeriod: 20s}
          expect(r.stdout).to match %r{stickiness_sessRatePeriod: 20s}
          expect(r.stdout).to match %r{stickiness_httpReqRatePeriod: 20s}
          expect(r.stdout).to match %r{stickiness_httpErrRatePeriod: 20s}
          expect(r.stdout).to match %r{stickiness_bytesInRatePeriod: 2m}
          expect(r.stdout).to match %r{stickiness_bytesOutRatePeriod: 2m}
          expect(r.stdout).to match %r{http2Enabled: '0'}
          expect(r.stdout).to match %r{http2Enabled_nontls: '0'}
          expect(r.stdout).to match %r{advertised_protocols: h2}
          expect(r.stdout).to match %r{forwardFor: '0'}
          expect(r.stdout).to match %r{connectionBehaviour: http-tunnel}
          expect(r.stdout).to match %r{customOptions: ''}
          expect(r.stdout).to match %r{linkedActions: '\[\]'}
          expect(r.stdout).to match %r{linkedErrorfiles: '\[\]'}
        end
      end
    end

    describe 'delete webserver_frontend' do
      pp = <<-MANIFEST
        opnsense_haproxy_frontend { 'webserver_frontend':
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the rule as deleted via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('haproxy frontend list -o plain -c name')) do |r|
          expect(r.stdout).not_to match %r{webserver_frontend\n}
        end
      end
    end
  end
end
