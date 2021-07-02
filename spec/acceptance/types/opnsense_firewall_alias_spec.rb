require 'spec_helper_acceptance'

describe 'opnsense_firewall_alias' do
  before(:all) do
    setup_test_api_endpoint
  end
  after(:all) do
    #teardown_test_api_endpoint
  end

  context 'for opnsense-test.device.com' do
    describe 'add alias for each alias type' do
      pp = <<-MANIFEST
        opnsense_firewall_alias { 'hosts_alias':
          device      => 'opnsense-test.device.com',
          type        => 'host',
          content     => '10.0.0.1,!10.0.0.5',
          description => 'Some hosts',
          counters    => true,
          enabled     => true,
          ensure      => 'present',
        }

        opnsense_firewall_alias { 'network_alias':
          device      => 'opnsense-test.device.com',
          type        => 'network',
          content     => '192.168.1.0/24,!192.168.1.128/25',
          description => 'Some networks',
          counters    => true,
          enabled     => true,
          ensure      => 'present',
        }

        opnsense_firewall_alias { 'ports_alias':
          device      => 'opnsense-test.device.com',
          type        => 'port',
          content     => '80,443',
          description => 'Some ports',
          enabled     => true,
          ensure      => 'present',
        }

        opnsense_firewall_alias { 'url_alias':
          device      => 'opnsense-test.device.com',
          type        => 'url',
          content     => 'https://www.spamhaus.org/drop/drop.txt,https://www.spamhaus.org/drop/edrop.txt',
          description => 'spamhaus fetched once.',
          counters    => true,
          enabled     => true,
          ensure      => 'present',
        }

        opnsense_firewall_alias { 'url_table_alias':
          device      => 'opnsense-test.device.com',
          type        => 'urltable',
          content     => 'https://www.spamhaus.org/drop/drop.txt, https://www.spamhaus.org/drop/edrop.txt',
          description => 'Spamhaus block list',
          updatefreq  => 0.5,
          counters    => true,
          enabled     => true,
          ensure      => 'present',
        }

        opnsense_firewall_alias { 'geoip_alias':
          device      => 'opnsense-test.device.com',
          type        => 'geoip',
          content     => 'DE,GR',
          description => 'Only german and greek IPv4 and IPV6 addresses',
          proto       => "IPv4,IPv6",
          counters    => true,
          enabled     => true,
          ensure      => 'present',
        }

        opnsense_firewall_alias { 'networkgroup_alias':
          device      => 'opnsense-test.device.com',
          type        => 'networkgroup',
          content     => ['hosts_alias','network_alias'],
          description => 'Combine different network aliases into one',
          counters    => true,
          enabled     => true,
          ensure      => 'present',
        }

        opnsense_firewall_alias { 'mac_alias':
          device      => 'opnsense-test.device.com',
          type        => 'mac',
          content     => ['f4:90:ea', '0c:4d:e9:b1:05:f0'],
          description => 'MAC address or partial mac addresses',
          counters    => true,
          enabled     => true,
          ensure      => 'present',
        }

        opnsense_firewall_alias { 'external_alias':
          device      => 'opnsense-test.device.com',
          type        => 'external',
          description => 'Externally managed alias, this only handles the placeholder.',
          proto       => "IPv4",
          counters    => true,
          enabled     => true,
          ensure      => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the created aliased via the cli', retry: 3, retry_wait: 10 do
        run_shell(build_opn_cli_cmd('firewall alias show new_url_table')) do |r|
          expect(r.stdout).to match %r{os-helloworld}
        end
      end
    end

    describe 'update alias url_table_alias' do
      pp = <<-MANIFEST
      opnsense_firewall_alias { 'url_table_alias':
        device      => 'opnsense-test.device.com',
        type        => 'urltable',
        content     => 'https://www.spamhaus.org/drop/drop.txt',
        description => 'Spamhaus block list reduced',
        updatefreq  => 0.75,
        counters    => false,
        enabled     => false,
        ensure      => 'present',
      }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the alias via the cli', retry: 3, retry_wait: 10 do
        run_shell(build_opn_cli_cmd('firewall alias list')) do |r|
          expect(r.stdout).to match %r{hosts_alias}
          expect(r.stdout).to match %r{network_alias}
          expect(r.stdout).to match %r{ports_alias}
          expect(r.stdout).to match %r{url_alias}
          expect(r.stdout).to match %r{url_table_alias}
          expect(r.stdout).to match %r{geoip_alias}
          expect(r.stdout).to match %r{networkgroup_alias}
          expect(r.stdout).to match %r{mac_alias}
          expect(r.stdout).to match %r{external_alias}
        end
      end
    end

    describe 'delete firewall alias new_url_table' do
      pp = <<-MANIFEST
        $delete_aliases = [
          'hosts_alias',
          'network_alias',
          'ports_alias',
          'url_alias',
          'url_table_alias',
          'geoip_alias',
          'networkgroup_alias',
          'mac_alias',
          'external_alias',
        ]
        opnsense_firewall_alias { $delete_aliases:
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the plugin as installed via the cli', retry: 3, retry_wait: 10 do
        run_shell(build_opn_cli_cmd('firewall alias list')) do |r|
          expect(r.stdout).not_to match %r{hosts_alias}
          expect(r.stdout).not_to match %r{network_alias}
          expect(r.stdout).not_to match %r{ports_alias}
          expect(r.stdout).not_to match %r{url_alias}
          expect(r.stdout).not_to match %r{url_table_alias}
          expect(r.stdout).not_to match %r{geoip_alias}
          expect(r.stdout).not_to match %r{networkgroup_alias}
          expect(r.stdout).not_to match %r{mac_alias}
          expect(r.stdout).not_to match %r{external_alias}
        end
      end
    end
  end
end
