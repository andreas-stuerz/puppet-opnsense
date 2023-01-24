require 'spec_helper_acceptance'

describe 'opnsense_nodeexporter_config' do
  context 'for opnsense-test.device.com' do
    describe 'update' do
      pp = <<-MANIFEST
        opnsense_nodeexporter_config { 'opnsense-test.device.com':
          enabled        => true,
          listen_address => '192.168.1.1',
          listen_port    => '9200',
          cpu            => false,
          exec           => false,
          filesystem     => false,
          loadavg        => false,
          meminfo        => false,
          netdev         => false,
          time           => false,
          devstat        => false,
          interrupts     => true,
          ntp            => true,
          zfs            => true,
          ensure         => 'present',
        }

      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the updated nodeexporter config via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('nodeexporter config show -o yaml')) do |r|
          expect(r.stdout).to match %r{enabled: '1'}
          expect(r.stdout).to match %r{listenaddress: 192.168.1.1}
          expect(r.stdout).to match %r{listenport: '9200'}
          expect(r.stdout).to match %r{cpu: '0'}
          expect(r.stdout).to match %r{exec: '0'}
          expect(r.stdout).to match %r{filesystem: '0'}
          expect(r.stdout).to match %r{loadavg: '0'}
          expect(r.stdout).to match %r{meminfo: '0'}
          expect(r.stdout).to match %r{netdev: '0'}
          expect(r.stdout).to match %r{time: '0'}
          expect(r.stdout).to match %r{devstat: '0'}
          expect(r.stdout).to match %r{interrupts: '1'}
          expect(r.stdout).to match %r{ntp: '1'}
          expect(r.stdout).to match %r{zfs: '1'}
        end
      end
    end

    describe 'reset' do
      pp = <<-MANIFEST
        opnsense_nodeexporter_config { 'opnsense-test.device.com':
          enabled        => false,
          listen_address => '0.0.0.0',
          listen_port    => '9100',
          cpu            => true,
          exec           => true,
          filesystem     => true,
          loadavg        => true,
          meminfo        => true,
          netdev         => true,
          time           => true,
          devstat        => true,
          interrupts     => false,
          ntp            => false,
          zfs            => false,
          ensure         => 'present',
        }

      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the updated nodeexporter config via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('nodeexporter config show -o yaml')) do |r|
          expect(r.stdout).to match %r{enabled: '0'}
          expect(r.stdout).to match %r{listenaddress: 0.0.0.0}
          expect(r.stdout).to match %r{listenport: '9100'}
          expect(r.stdout).to match %r{cpu: '1'}
          expect(r.stdout).to match %r{exec: '1'}
          expect(r.stdout).to match %r{filesystem: '1'}
          expect(r.stdout).to match %r{loadavg: '1'}
          expect(r.stdout).to match %r{meminfo: '1'}
          expect(r.stdout).to match %r{netdev: '1'}
          expect(r.stdout).to match %r{time: '1'}
          expect(r.stdout).to match %r{devstat: '1'}
          expect(r.stdout).to match %r{interrupts: '0'}
          expect(r.stdout).to match %r{ntp: '0'}
          expect(r.stdout).to match %r{zfs: '0'}
        end
      end
    end
  end
end
