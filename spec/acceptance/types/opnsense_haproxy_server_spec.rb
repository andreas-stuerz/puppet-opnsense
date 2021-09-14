require 'spec_helper_acceptance'

describe 'opnsense_haproxy_server' do
  context 'for opnsense-test.device.com' do
    describe 'add webserver1' do
      pp = <<-MANIFEST
        opnsense_haproxy_server { 'webserver1':
          device                 => 'opnsense-test.device.com',
          enabled                => true,
          description            => 'primary webserver',
          address                => 'webserver1.example.com',
          port                   => '443',
          checkport              => '80',
          mode                   => 'active',
          type                   => 'static',
          service_name           => '',
          linked_resolver        => '',
          resolver_opts          => ['allow-dup-ip','ignore-weight','prevent-dup-ip'],
          resolve_prefer         => 'ipv4',
          ssl                    => true,
          ssl_verify             => true,
          ssl_ca                 => [],
          ssl_crl                => [],
          ssl_client_certificate => '5eba6f0f352e3',
          weight                 => '10',
          check_interval         => '100',
          check_down_interval    => '200',
          source                 => '10.0.0.1',
          advanced               => 'send-proxy',
          ensure                 => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the created rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'enabled', 'name', 'description', 'address', 'port', 'checkport', 'mode', 'type', 'serviceName',
          'linkedResolver', 'resolverOpts', 'resolvePrefer', 'ssl', 'sslVerify', 'sslCA', 'sslCRL',
          'sslClientCertificate', 'weight', 'checkInterval', 'checkDownInterval', 'source', 'advanced'
        ].join(',')
        run_shell(build_opn_cli_cmd("haproxy server list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{enabled: '1'}
          expect(r.stdout).to match %r{name: webserver1}
          expect(r.stdout).to match %r{description: primary webserver}
          expect(r.stdout).to match %r{address: webserver1.example.com}
          expect(r.stdout).to match %r{port: '443'}
          expect(r.stdout).to match %r{checkport: '80'}
          expect(r.stdout).to match %r{mode: active}
          expect(r.stdout).to match %r{type: static}
          expect(r.stdout).to match %r{serviceName: ''}
          expect(r.stdout).to match %r{linkedResolver: ''}
          expect(r.stdout).to match %r{resolverOpts: allow-dup-ip,ignore-weight,prevent-dup-ip}
          expect(r.stdout).to match %r{resolvePrefer: ipv4}
          expect(r.stdout).to match %r{ssl: '1'}
          expect(r.stdout).to match %r{sslVerify: '1'}
          expect(r.stdout).to match %r{sslCA: ''}
          expect(r.stdout).to match %r{sslCRL: ''}
          expect(r.stdout).to match %r{sslClientCertificate: 5eba6f0f352e3}
          expect(r.stdout).to match %r{weight: '10'}
          expect(r.stdout).to match %r{checkInterval: '100'}
          expect(r.stdout).to match %r{checkDownInterval: '200'}
          expect(r.stdout).to match %r{source: 10.0.0.1}
          expect(r.stdout).to match %r{advanced: send-proxy}
        end
      end
    end

    describe 'update webserver1' do
      pp = <<-MANIFEST
        opnsense_haproxy_server { 'webserver1':
          device                 => 'opnsense-test.device.com',
          enabled                => false,
          description            => 'primary webserver modified',
          address                => 'webserver1.example.de',
          port                   => '80',
          checkport              => '443',
          mode                   => 'backup',
          type                   => 'static',
          service_name           => '',
          linked_resolver        => '',
          resolver_opts          => ['allow-dup-ip','ignore-weight'],
          resolve_prefer         => 'ipv6',
          ssl                    => false,
          ssl_verify             => false,
          ssl_ca                 => [],
          ssl_crl                => [],
          ssl_client_certificate => '',
          weight                 => '20',
          check_interval         => '200',
          check_down_interval    => '400',
          source                 => '10.0.0.2',
          advanced               => '',
          ensure                 => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the updated rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'enabled', 'name', 'description', 'address', 'port', 'checkport', 'mode', 'type', 'serviceName',
          'linkedResolver', 'resolverOpts', 'resolvePrefer', 'ssl', 'sslVerify', 'sslCA', 'sslCRL',
          'sslClientCertificate', 'weight', 'checkInterval', 'checkDownInterval', 'source', 'advanced'
        ].join(',')
        run_shell(build_opn_cli_cmd("haproxy server list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{enabled: '0'}
          expect(r.stdout).to match %r{name: webserver1}
          expect(r.stdout).to match %r{description: primary webserver modified}
          expect(r.stdout).to match %r{address: webserver1.example.de}
          expect(r.stdout).to match %r{port: '80'}
          expect(r.stdout).to match %r{checkport: '443'}
          expect(r.stdout).to match %r{mode: backup}
          expect(r.stdout).to match %r{type: static}
          expect(r.stdout).to match %r{serviceName: ''}
          expect(r.stdout).to match %r{linkedResolver: ''}
          expect(r.stdout).to match %r{resolverOpts: allow-dup-ip,ignore-weight}
          expect(r.stdout).to match %r{resolvePrefer: ipv6}
          expect(r.stdout).to match %r{ssl: '0'}
          expect(r.stdout).to match %r{sslVerify: '0'}
          expect(r.stdout).to match %r{sslCA: ''}
          expect(r.stdout).to match %r{sslCRL: ''}
          expect(r.stdout).to match %r{sslClientCertificate: ''}
          expect(r.stdout).to match %r{weight: '20'}
          expect(r.stdout).to match %r{checkInterval: '200'}
          expect(r.stdout).to match %r{checkDownInterval: '400'}
          expect(r.stdout).to match %r{source: 10.0.0.2}
          expect(r.stdout).to match %r{advanced: ''}
        end
      end
    end

    describe 'delete webserver1' do
      pp = <<-MANIFEST
        opnsense_haproxy_server { 'webserver1':
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the rule as deleted via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('haproxy server list -o plain -c name')) do |r|
          expect(r.stdout).not_to match %r{webserver1\n}
        end
      end
    end
  end
end
