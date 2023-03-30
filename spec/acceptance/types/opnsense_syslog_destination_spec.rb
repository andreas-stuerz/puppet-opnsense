require 'spec_helper_acceptance'

describe 'opnsense_syslog_destination' do
  context 'for opnsense-test.device.com' do
    describe 'add syslog_destination acceptance test item' do
      pp = <<-MANIFEST
        opnsense_syslog_destination { 'acceptance test syslog destination':
          device      => 'opnsense-test.device.com',
          enabled     => true,
          transport   => 'tls4',
          program     => 'ntp,ntpdate,ntpd',
          level       => ['info', 'notice', 'warn', 'err', 'crit', 'alert', 'emerg'],
          facility    => ['ntp', 'security', 'console'],
          hostname    => '10.0.0.2',
          certificate => '60cc4641eb577',
          port        => '514',
          rfc5424     => true,
          ensure      => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the created rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'enabled',
          'transport',
          'program',
          'level',
          'facility',
          'hostname',
          'certificate',
          'port',
          'rfc5424',
          'description',

        ].join(',')
        run_shell(build_opn_cli_cmd("syslog destination list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{enabled: '1'}
          expect(r.stdout).to match %r{transport: tls4}
          expect(r.stdout).to match %r{program: ntp,ntpd,ntpdate}
          expect(r.stdout).to match %r{level: info,notice,warn,err,crit,alert,emerg}
          expect(r.stdout).to match %r{facility: ntp,security,console}
          expect(r.stdout).to match %r{hostname: 10.0.0.2}
          expect(r.stdout).to match %r{certificate: 60cc4641eb577}
          expect(r.stdout).to match %r{port: '514'}
          expect(r.stdout).to match %r{rfc5424: '1'}
          expect(r.stdout).to match %r{description: acceptance test syslog destination}
        end
      end
    end

    describe 'update syslog_destination acceptance test item' do
      pp = <<-MANIFEST
        opnsense_syslog_destination { 'acceptance test syslog destination':
          device      => 'opnsense-test.device.com',
          enabled     => false,
          transport   => 'tcp4',
          program     => 'ntp,ntpdate',
          level       => ['crit', 'alert', 'emerg'],
          facility    => ['ntp'],
          hostname    => '10.0.0.1',
          certificate => '',
          port        => '10514',
          rfc5424     => false,
          ensure      => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the updated rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'enabled',
          'transport',
          'program',
          'level',
          'facility',
          'hostname',
          'certificate',
          'port',
          'rfc5424',
          'description',

        ].join(',')
        run_shell(build_opn_cli_cmd("syslog destination list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{enabled: '0'}
          expect(r.stdout).to match %r{transport: tcp4}
          expect(r.stdout).to match %r{program: ntp,ntpdate}
          expect(r.stdout).to match %r{level: crit,alert,emerg}
          expect(r.stdout).to match %r{facility: ntp}
          expect(r.stdout).to match %r{hostname: 10.0.0.1}
          expect(r.stdout).to match %r{certificate: ''}
          expect(r.stdout).to match %r{port: '10514'}
          expect(r.stdout).to match %r{rfc5424: '0'}
          expect(r.stdout).to match %r{description: acceptance test syslog destination}
        end
      end
    end

    describe 'delete syslog_destination acceptance test item' do
      pp = <<-MANIFEST
        opnsense_syslog_destination { 'acceptance test syslog destination':
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the rule as deleted via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('syslog destination list -o plain -c description}')) do |r|
          expect(r.stdout).not_to match %r{acceptance test syslog destination\n}
        end
      end
    end
  end
end
