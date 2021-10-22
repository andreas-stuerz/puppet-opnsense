require 'spec_helper_acceptance'

describe 'opnsense_haproxy_backend' do
  context 'for opnsense-test.device.com' do
    describe 'add webserver_pool' do
      pp = <<-MANIFEST
      opnsense_haproxy_backend { 'webserver_pool':
        device                           => 'opnsense-test.device.com',
        enabled                          => true,
        description                      => 'backend for webserver',
        mode                             => 'http',
        algorithm                        => 'source',
        random_draws                     => '2',
        proxy_protocol                   => '',
        linked_servers                   => [],
        linked_resolver                  => '',
        resolver_opts                    => [],
        resolve_prefer                   => '',
        source                           => '',
        health_check_enabled             => true,
        health_check                     => '',
        health_check_log_status          => true,
        check_interval                   => '',
        check_down_interval              => '',
        health_check_fall                => '',
        health_check_rise                => '',
        linked_mailer                    => '',
        http2_enabled                    => true,
        http2_enabled_nontls             => true,
        ba_advertised_protocols          => ['h2', 'http11'],
        persistence                      => 'sticktable',
        persistence_cookiemode           => 'piggyback',
        persistence_cookiename           => 'SRVCOOKIE',
        persistence_stripquotes          => true,
        stickiness_pattern               => 'sourceipv4',
        stickiness_data_types            => [],
        stickiness_expire                => '30m',
        stickiness_size                  => '50k',
        stickiness_cookiename            => '',
        stickiness_cookielength          => '',
        stickiness_conn_rate_period      => '10s',
        stickiness_sess_rate_period      => '10s',
        stickiness_http_req_rate_period  => '10s',
        stickiness_http_err_rate_period  => '10s',
        stickiness_bytes_in_rate_period  => '1m',
        stickiness_bytes_out_rate_period => '1m',
        basic_auth_enabled               => true,
        basic_auth_users                 => [],
        basic_auth_groups                => [],
        tuning_timeout_connect           => '',
        tuning_timeout_check             => '',
        tuning_timeout_server            => '',
        tuning_retries                   => '',
        custom_options                   => '',
        tuning_defaultserver             => '',
        tuning_noport                    => true,
        tuning_httpreuse                 => 'safe',
        tuning_caching                   => true,
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
          'enabled', 'name', 'description', 'mode', 'algorithm', 'random_draws', 'proxyProtocol', 'linkedServers',
          'linkedResolver', 'resolverOpts', 'resolvePrefer', 'source', 'healthCheckEnabled', 'healthCheck',
          'healthCheckLogStatus', 'checkInterval', 'checkDownInterval', 'healthCheckFall', 'healthCheckRise',
          'linkedMailer', 'http2Enabled', 'http2Enabled_nontls', 'ba_advertised_protocols', 'persistence',
          'persistence_cookiemode', 'persistence_cookiename', 'persistence_stripquotes', 'stickiness_pattern',
          'stickiness_dataTypes', 'stickiness_expire', 'stickiness_size', 'stickiness_cookiename',
          'stickiness_cookielength', 'stickiness_connRatePeriod', 'stickiness_sessRatePeriod',
          'stickiness_httpReqRatePeriod', 'stickiness_httpErrRatePeriod', 'stickiness_bytesInRatePeriod',
          'stickiness_bytesOutRatePeriod', 'basicAuthEnabled', 'basicAuthUsers', 'basicAuthGroups',
          'tuning_timeoutConnect', 'tuning_timeoutCheck', 'tuning_timeoutServer', 'tuning_retries', 'customOptions',
          'tuning_defaultserver', 'tuning_noport', 'tuning_httpreuse', 'tuning_caching',
          'linkedActions', 'linkedErrorfiles'
        ].join(',')
        run_shell(build_opn_cli_cmd("haproxy backend list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{enabled: '1'}
          expect(r.stdout).to match %r{name: webserver_pool}
          expect(r.stdout).to match %r{description: backend for webserver}
          expect(r.stdout).to match %r{mode: http}
          expect(r.stdout).to match %r{algorithm: source}
          expect(r.stdout).to match %r{random_draws: '2'}
          expect(r.stdout).to match %r{proxyProtocol: ''}
          expect(r.stdout).to match %r{linkedServers: '\[\]'}
          expect(r.stdout).to match %r{linkedResolver: ''}
          expect(r.stdout).to match %r{resolverOpts: ''}
          expect(r.stdout).to match %r{resolvePrefer: ''}
          expect(r.stdout).to match %r{source: ''}
          expect(r.stdout).to match %r{healthCheckEnabled: '1'}
          expect(r.stdout).to match %r{healthCheck: ''}
          expect(r.stdout).to match %r{healthCheckLogStatus: '1'}
          expect(r.stdout).to match %r{checkInterval: ''}
          expect(r.stdout).to match %r{checkDownInterval: ''}
          expect(r.stdout).to match %r{healthCheckFall: ''}
          expect(r.stdout).to match %r{healthCheckRise: ''}
          expect(r.stdout).to match %r{linkedMailer: ''}
          expect(r.stdout).to match %r{http2Enabled: '1'}
          expect(r.stdout).to match %r{http2Enabled_nontls: '1'}
          expect(r.stdout).to match %r{ba_advertised_protocols: h2,http11}
          expect(r.stdout).to match %r{persistence: sticktable}
          expect(r.stdout).to match %r{persistence_cookiemode: piggyback}
          expect(r.stdout).to match %r{persistence_cookiename: SRVCOOKIE}
          expect(r.stdout).to match %r{persistence_stripquotes: '1'}
          expect(r.stdout).to match %r{stickiness_pattern: sourceipv4}
          expect(r.stdout).to match %r{stickiness_dataTypes: ''}
          expect(r.stdout).to match %r{stickiness_expire: 30m}
          expect(r.stdout).to match %r{stickiness_size: 50k}
          expect(r.stdout).to match %r{stickiness_cookiename: ''}
          expect(r.stdout).to match %r{stickiness_cookielength: ''}
          expect(r.stdout).to match %r{stickiness_connRatePeriod: 10s}
          expect(r.stdout).to match %r{stickiness_sessRatePeriod: 10s}
          expect(r.stdout).to match %r{stickiness_httpReqRatePeriod: 10s}
          expect(r.stdout).to match %r{stickiness_httpErrRatePeriod: 10s}
          expect(r.stdout).to match %r{stickiness_bytesInRatePeriod: 1m}
          expect(r.stdout).to match %r{stickiness_bytesOutRatePeriod: 1m}
          expect(r.stdout).to match %r{basicAuthEnabled: '1'}
          expect(r.stdout).to match %r{basicAuthUsers: '\[\]'}
          expect(r.stdout).to match %r{basicAuthGroups: '\[\]'}
          expect(r.stdout).to match %r{tuning_timeoutConnect: ''}
          expect(r.stdout).to match %r{tuning_timeoutCheck: ''}
          expect(r.stdout).to match %r{tuning_timeoutServer: ''}
          expect(r.stdout).to match %r{tuning_retries: ''}
          expect(r.stdout).to match %r{customOptions: ''}
          expect(r.stdout).to match %r{tuning_defaultserver: ''}
          expect(r.stdout).to match %r{tuning_noport: '1'}
          expect(r.stdout).to match %r{tuning_httpreuse: safe}
          expect(r.stdout).to match %r{tuning_caching: '1'}
          expect(r.stdout).to match %r{linkedActions: '\[\]'}
          expect(r.stdout).to match %r{linkedErrorfiles: '\[\]'}
        end
      end
    end

    describe 'update webserver_pool' do
      pp = <<-MANIFEST
      opnsense_haproxy_backend { 'webserver_pool':
        device                           => 'opnsense-test.device.com',
        enabled                          => true,
        description                      => 'backend for webserver modified',
        mode                             => 'tcp',
        algorithm                        => 'roundrobin',
        random_draws                     => '3',
        proxy_protocol                   => 'v1',
        linked_servers                   => [],
        linked_resolver                  => '',
        resolver_opts                    => ['allow-dup-ip'],
        resolve_prefer                   => 'ipv4',
        source                           => '10.0.0.2',
        health_check_enabled             => false,
        health_check                     => '',
        health_check_log_status          => false,
        check_interval                   => '100',
        check_down_interval              => '100',
        health_check_fall                => '2',
        health_check_rise                => '2',
        linked_mailer                    => '',
        http2_enabled                    => false,
        http2_enabled_nontls             => false,
        ba_advertised_protocols          => ['http11'],
        persistence                      => 'sticktable',
        persistence_cookiemode           => 'piggyback',
        persistence_cookiename           => 'SRVCOOKIE',
        persistence_stripquotes          => true,
        stickiness_pattern               => 'sourceipv6',
        stickiness_data_types            => ['conn_cnt'],
        stickiness_expire                => '20m',
        stickiness_size                  => '60k',
        stickiness_cookiename            => 'cookie2',
        stickiness_cookielength          => '20',
        stickiness_conn_rate_period      => '15s',
        stickiness_sess_rate_period      => '15s',
        stickiness_http_req_rate_period  => '15s',
        stickiness_http_err_rate_period  => '15s',
        stickiness_bytes_in_rate_period  => '2m',
        stickiness_bytes_out_rate_period => '2m',
        basic_auth_enabled               => false,
        basic_auth_users                 => [],
        basic_auth_groups                => [],
        tuning_timeout_connect           => '20s',
        tuning_timeout_check             => '20s',
        tuning_timeout_server            => '20s',
        tuning_retries                   => '2',
        custom_options                   => 'http-reuse safe',
        tuning_defaultserver             => 'port 21',
        tuning_noport                    => false,
        tuning_httpreuse                 => 'never',
        tuning_caching                   => false,
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
          'enabled', 'name', 'description', 'mode', 'algorithm', 'random_draws', 'proxyProtocol', 'linkedServers',
          'linkedResolver', 'resolverOpts', 'resolvePrefer', 'source', 'healthCheckEnabled', 'healthCheck',
          'healthCheckLogStatus', 'checkInterval', 'checkDownInterval', 'healthCheckFall', 'healthCheckRise',
          'linkedMailer', 'http2Enabled', 'http2Enabled_nontls', 'ba_advertised_protocols', 'persistence',
          'persistence_cookiemode', 'persistence_cookiename', 'persistence_stripquotes', 'stickiness_pattern',
          'stickiness_dataTypes', 'stickiness_expire', 'stickiness_size', 'stickiness_cookiename',
          'stickiness_cookielength', 'stickiness_connRatePeriod', 'stickiness_sessRatePeriod',
          'stickiness_httpReqRatePeriod', 'stickiness_httpErrRatePeriod', 'stickiness_bytesInRatePeriod',
          'stickiness_bytesOutRatePeriod', 'basicAuthEnabled', 'basicAuthUsers', 'basicAuthGroups',
          'tuning_timeoutConnect', 'tuning_timeoutCheck', 'tuning_timeoutServer', 'tuning_retries', 'customOptions',
          'tuning_defaultserver', 'tuning_noport', 'tuning_httpreuse', 'tuning_caching',
          'linkedActions', 'linkedErrorfiles'
        ].join(',')
        run_shell(build_opn_cli_cmd("haproxy backend list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{enabled: '1'}
          expect(r.stdout).to match %r{name: webserver_pool}
          expect(r.stdout).to match %r{description: backend for webserver modified}
          expect(r.stdout).to match %r{mode: tcp}
          expect(r.stdout).to match %r{algorithm: roundrobin}
          expect(r.stdout).to match %r{random_draws: '3'}
          expect(r.stdout).to match %r{proxyProtocol: v1}
          expect(r.stdout).to match %r{linkedServers: '\[\]'}
          expect(r.stdout).to match %r{linkedResolver: ''}
          expect(r.stdout).to match %r{resolverOpts: allow-dup-ip}
          expect(r.stdout).to match %r{resolvePrefer: ipv4}
          expect(r.stdout).to match %r{source: 10.0.0.2}
          expect(r.stdout).to match %r{healthCheckEnabled: '0'}
          expect(r.stdout).to match %r{healthCheck: ''}
          expect(r.stdout).to match %r{healthCheckLogStatus: '0'}
          expect(r.stdout).to match %r{checkInterval: '100'}
          expect(r.stdout).to match %r{checkDownInterval: '100'}
          expect(r.stdout).to match %r{healthCheckFall: '2'}
          expect(r.stdout).to match %r{healthCheckRise: '2'}
          expect(r.stdout).to match %r{linkedMailer: ''}
          expect(r.stdout).to match %r{http2Enabled: '0'}
          expect(r.stdout).to match %r{http2Enabled_nontls: '0'}
          expect(r.stdout).to match %r{ba_advertised_protocols: http11}
          expect(r.stdout).to match %r{persistence: sticktable}
          expect(r.stdout).to match %r{persistence_cookiemode: piggyback}
          expect(r.stdout).to match %r{persistence_cookiename: SRVCOOKIE}
          expect(r.stdout).to match %r{persistence_stripquotes: '1'}
          expect(r.stdout).to match %r{stickiness_pattern: sourceipv6}
          expect(r.stdout).to match %r{stickiness_dataTypes: conn_cnt}
          expect(r.stdout).to match %r{stickiness_expire: 20m}
          expect(r.stdout).to match %r{stickiness_size: 60k}
          expect(r.stdout).to match %r{stickiness_cookiename: cookie2}
          expect(r.stdout).to match %r{stickiness_cookielength: '20'}
          expect(r.stdout).to match %r{stickiness_connRatePeriod: 15s}
          expect(r.stdout).to match %r{stickiness_sessRatePeriod: 15s}
          expect(r.stdout).to match %r{stickiness_httpReqRatePeriod: 15s}
          expect(r.stdout).to match %r{stickiness_httpErrRatePeriod: 15s}
          expect(r.stdout).to match %r{stickiness_bytesInRatePeriod: 2m}
          expect(r.stdout).to match %r{stickiness_bytesOutRatePeriod: 2m}
          expect(r.stdout).to match %r{basicAuthEnabled: '0'}
          expect(r.stdout).to match %r{basicAuthUsers: '\[\]'}
          expect(r.stdout).to match %r{basicAuthGroups: '\[\]'}
          expect(r.stdout).to match %r{tuning_timeoutConnect: 20s}
          expect(r.stdout).to match %r{tuning_timeoutCheck: 20s}
          expect(r.stdout).to match %r{tuning_timeoutServer: 20s}
          expect(r.stdout).to match %r{tuning_retries: '2'}
          expect(r.stdout).to match %r{customOptions: http-reuse safe}
          expect(r.stdout).to match %r{tuning_defaultserver: port 21}
          expect(r.stdout).to match %r{tuning_noport: '0'}
          expect(r.stdout).to match %r{tuning_httpreuse: never}
          expect(r.stdout).to match %r{tuning_caching: '0'}
          expect(r.stdout).to match %r{linkedActions: '\[\]'}
          expect(r.stdout).to match %r{linkedErrorfiles: '\[\]'}
        end
      end
    end

    describe 'delete webserver_pool' do
      pp = <<-MANIFEST
        opnsense_haproxy_backend { 'webserver_pool':
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the rule as deleted via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('haproxy backend list -o plain -c name')) do |r|
          expect(r.stdout).not_to match %r{webserver_pool}
        end
      end
    end
  end
end
