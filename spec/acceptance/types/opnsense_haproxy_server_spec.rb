require 'spec_helper_acceptance'

describe 'opnsense_haproxy_server' do
  context 'for opnsense-test.device.com' do
    describe 'add rule acceptance test rule' do
      pp = <<-MANIFEST
        opnsense_haproxy_server { 'acceptance test rule':
          device           => 'opnsense-test.device.com',
          sequence         => '1',
          action           => 'pass',
          direction        => 'in',
          ipprotocol       => 'inet',
          interface        => ['lan', 'wan'],
          source_net       => '192.168.50.0/24',
          source_port      => '10000-20000',
          source_not       => false,
          protocol         => 'TCP',
          destination_net  => '10.0.40.0/24',
          destination_port => '443',
          destination_not  => false,
          gateway          => '',
          quick            => true,
          log              => false,
          enabled          => true,
          ensure           => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the created rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'sequence', 'action', 'direction', 'ipprotocol', 'interface', 'source_net', 'source_port', 'source_not',
          'protocol', 'destination_net', 'destination_port', 'destination_not', 'description', 'gateway', 'quick',
          'log', 'enabled'
        ].join(',')
        run_shell(build_opn_cli_cmd("firewall rule list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{sequence: '1'}
          expect(r.stdout).to match %r{action: pass}
          expect(r.stdout).to match %r{direction: in}
          expect(r.stdout).to match %r{ipprotocol: inet}
          expect(r.stdout).to match %r{interface: lan,wan}
          expect(r.stdout).to match %r{source_net: 192.168.50.0/24}
          expect(r.stdout).to match %r{source_port: 10000-20000}
          expect(r.stdout).to match %r{source_not: '0'}
          expect(r.stdout).to match %r{protocol: TCP}
          expect(r.stdout).to match %r{destination_net: 10.0.40.0/24}
          expect(r.stdout).to match %r{destination_port: '443'}
          expect(r.stdout).to match %r{destination_not: '0'}
          expect(r.stdout).to match %r{description: acceptance test rule}
          expect(r.stdout).to match %r{gateway: ''}
          expect(r.stdout).to match %r{quick: '1'}
          expect(r.stdout).to match %r{log: '0'}
          expect(r.stdout).to match %r{enabled: '1'}
        end
      end
    end

    describe 'update rule acceptance test rule' do
      pp = <<-MANIFEST
        opnsense_haproxy_server { 'acceptance test rule':
          device           => 'opnsense-test.device.com',
          sequence         => '2',
          action           => 'block',
          direction        => 'out',
          ipprotocol       => 'inet',
          interface        => ['lan'],
          source_net       => '192.168.60.0/24',
          source_port      => '9999',
          source_not       => false,
          protocol         => 'TCP',
          destination_net  => '10.0.60.0/24',
          destination_port => 'http',
          destination_not  => false,
          gateway          => 'Null4',
          quick            => false,
          log              => true,
          enabled          => false,
          ensure           => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the updated rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'sequence', 'action', 'direction', 'ipprotocol', 'interface', 'source_net', 'source_port', 'source_not',
          'protocol', 'destination_net', 'destination_port', 'destination_not', 'description', 'gateway', 'quick',
          'log', 'enabled'
        ].join(',')
        run_shell(build_opn_cli_cmd("firewall rule list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{sequence: '2'}
          expect(r.stdout).to match %r{action: block}
          expect(r.stdout).to match %r{direction: out}
          expect(r.stdout).to match %r{ipprotocol: inet}
          expect(r.stdout).to match %r{interface: lan}
          expect(r.stdout).to match %r{source_net: 192.168.60.0/24}
          expect(r.stdout).to match %r{source_port: '9999'}
          expect(r.stdout).to match %r{source_not: '0'}
          expect(r.stdout).to match %r{protocol: TCP}
          expect(r.stdout).to match %r{destination_net: 10.0.60.0/24}
          expect(r.stdout).to match %r{destination_port: http}
          expect(r.stdout).to match %r{destination_not: '0'}
          expect(r.stdout).to match %r{description: acceptance test rule}
          expect(r.stdout).to match %r{gateway: Null4}
          expect(r.stdout).to match %r{quick: '0'}
          expect(r.stdout).to match %r{log: '1'}
          expect(r.stdout).to match %r{enabled: '0'}
        end
      end
    end

    describe 'delete rule acceptance test rule' do
      pp = <<-MANIFEST
        opnsense_haproxy_server { 'acceptance test rule':
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the rule as deleted via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('firewall rule list -o plain -c description')) do |r|
          expect(r.stdout).not_to match %r{acceptance test rule\n}
        end
      end
    end
  end
end
