require 'spec_helper_acceptance'

describe 'class opnsense' do
  context 'manage remote device opnsense.remote.com' do
    describe 'setup' do
      api_config = hash_from_fixture_yaml_file('/acceptance/opn-cli/conf.yaml')
      pp = <<-MANIFEST
        class { 'opnsense':
          devices  => {
            "opnsense.remote.com" => {
              "url"         => "#{api_config['url']}",
              "api_key"     => "#{api_config['api_key']}",
              "api_secret"  => Sensitive("#{api_config['api_secret']}"),
              "ssl_verify"  => #{api_config['ssl_verify']},
              "timeout"     => #{api_config['timeout']},
              "ca"          => "#{api_config['ca']}",
              "plugins"     => {
                "os-helloworld" => {},
              },
              "ensure"      => "present"
            }
          },
          aliases => {
            "my_http_ports_remote" => {
              "devices"     => ["opnsense.remote.com"],
              "type"        => "port",
              "content"     => ["80", "443"],
              "description" => "my local web ports",
              "enabled"     => true,
              "ensure"      => "present"
            },
            "mac_alias_remote" => {
              "devices"     => ["opnsense.remote.com"],#{' '}
              "type"        => "mac",
              "content"     => ["f4:90:ea", "0c:4d:e9:b1:05:f0"],#{' '}
              "description" => "My local MAC address or partial mac addresses",#{' '}
              "counters"    => true,#{' '}
              "enabled"     => true,
              "ensure"      => "present"
            }
          },
          rules => {
            "allow all from lan and wan" => {
              "devices"   => ["opnsense.remote.com"],
              "sequence"  => "1",
              "action"    => "pass",
              "interface" => ["lan", "wan"]
            }
          },#{' '}
          manage_resources   => true,
          api_manager_prefix => "opnsense.remote.com api manager - ",
          required_plugins   => {
            "os-xen" => {}
          }
        }
      MANIFEST

      it 'applies with no errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'find the installed plugins via the cli', retry: 3, retry_wait: 10 do
        run_shell(build_opn_cli_cmd('plugin installed -o plain -c name')) do |r|
          expect(r.stdout).to match %r{os-helloworld\n}
          expect(r.stdout).to match %r{os-xen\n}
        end
      end

      it 'find the created aliases via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('firewall alias list -o plain -c name')) do |r|
          expect(r.stdout).to match %r{my_http_ports_remote\n}
          expect(r.stdout).to match %r{mac_alias_remote\n}
        end
      end

      it 'find the created rules via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('firewall rule list -o plain -c description')) do |r|
          expect(r.stdout).to match %r{opnsense.remote.com api manager - allow all from lan and wan\n}
        end
      end
    end

    describe 'remove items' do
      pp_items = <<-MANIFEST
        class { 'opnsense':
          devices  => {
            "opnsense.remote.com" => {
              "plugins" => {
                "os-helloworld" => {
                  "ensure" => "absent"
                }
              }
            }
          },
          aliases => {
            "my_http_ports_remote" => {
              "devices" => ["opnsense.remote.com"],
              "ensure" => "absent"
            },
            "mac_alias_remote" => {
              "devices" => ["opnsense.remote.com"],
              "ensure" => "absent"
            }
          },
          rules => {
            "allow all from lan and wan" => {
              "devices" => ["opnsense.remote.com"],
              "ensure" => "absent"
            }
          },#{' '}
          manage_resources   => true,
          api_manager_prefix =>"opnsense.remote.com api manager - ",
          required_plugins   => {
            "os-xen" => {
              "ensure" => "absent"
            }
          }
        }
      MANIFEST

      it 'applies remove items with no errors' do
        apply_manifest(pp_items, catch_failures: true)
      end

      it 'ensure plugins are deleted via the cli', retry: 3, retry_wait: 10 do
        run_shell(build_opn_cli_cmd('plugin installed -o plain -c name')) do |r|
          expect(r.stdout).not_to match %r{os-xen\n}
          expect(r.stdout).not_to match %r{os-helloworld\n}
        end
      end

      it 'ensure firewall aliases are deleted via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('firewall alias list -o plain -c name')) do |r|
          expect(r.stdout).not_to match %r{my_http_ports_remote\n}
          expect(r.stdout).not_to match %r{mac_alias_remote\n}
        end
      end

      it 'ensure firewall rules are deleted via the cli', retry: 3, retry_wait: 3 do
        run_shell(build_opn_cli_cmd('firewall rule list -o plain -c description')) do |r|
          expect(r.stdout).not_to match %r{opnsense.remote.com api manager - allow all from lan and wan\n}
        end
      end
    end

    describe 'remove devices' do
      pp_device = <<-MANIFEST
        class { 'opnsense':
          devices  => {
            "opnsense.remote.com" => {
              "ensure" => "absent"
            }
          },
          required_plugins   => {}
        }
      MANIFEST

      it 'applies config with no errors' do
        apply_manifest(pp_device, catch_failures: true)
      end

      describe file('/root/.puppet-opnsense/opnsense.remote.com-config.yaml') do
        it { is_expected.not_to exist }
      end
    end
  end
end
