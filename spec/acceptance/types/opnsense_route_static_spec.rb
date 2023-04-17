require 'spec_helper_acceptance'

describe 'opnsense_route_static' do
  context 'for opnsense-test.device.com' do
    describe 'add route_static acceptance test item' do
      pp = <<-MANIFEST
        opnsense_route_static { 'acceptance test item':
          device    => 'opnsense-test.device.com',
          network   => '10.0.0.98/24',
          gateway   => 'WAN_DHCP',
          disabled  => false,
          ensure    => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the created rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'network',
          'gateway',
          'descr',
          'disabled',

        ].join(',')
        run_shell(build_opn_cli_cmd("route static list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{network: 10.0.0.98/24}
          expect(r.stdout).to match %r{gateway: WAN_DHCP}
          expect(r.stdout).to match %r{descr: acceptance test item}
          expect(r.stdout).to match %r{disabled: '0'}
        end
      end
    end

    describe 'update route_static acceptance test item' do
      pp = <<-MANIFEST
        opnsense_route_static { 'acceptance test item':
          device    => 'opnsense-test.device.com',
          network   => '192.168.1.0/24',
          gateway   => 'Null4',
          disabled  => true,
          ensure    => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the updated rule via the cli', retry: 3, retry_wait: 3 do
        cols = [
          'network',
          'gateway',
          'descr',
          'disabled',

        ].join(',')
        run_shell(build_opn_cli_cmd("route static list -o yaml -c #{cols}")) do |r|
          expect(r.stdout).to match %r{network: 192.168.1.0/24}
          expect(r.stdout).to match %r{gateway: Null4}
          expect(r.stdout).to match %r{descr: acceptance test item}
          expect(r.stdout).to match %r{disabled: '1'}
        end
      end
    end

    describe 'delete route_static acceptance test item' do
      pp = <<-MANIFEST
        opnsense_route_static { 'acceptance test item':
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the rule as deleted via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('route static list -o plain -c descr')) do |r|
          expect(r.stdout).not_to match %r{acceptance test item\n}
        end
      end
    end
  end
end
