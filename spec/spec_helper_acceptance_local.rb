# frozen_string_literal: true

require 'singleton'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

def create_remote_file(name, dest_filepath, file_content)
  Tempfile.open name do |tempfile|
    File.open(tempfile.path, 'w') { |file| file.puts file_content }
    LitmusHelper.instance.bolt_upload_file(tempfile.path, dest_filepath)
  end
end

def install_test_dependencies
  pp_setup = <<-MANIFEST
          $packages = [
            'python3',
            'python3-pip',
          ]
          $pip_packages = [
            'opn-cli',
          ]
          package { $packages:
            ensure => present,
          }
          -> package { $pip_packages:
            ensure   => latest,
            provider => 'pip3',
          }
  MANIFEST
  LitmusHelper.instance.apply_manifest(pp_setup, expect_failures: false)
end

def deploy_fixtures(local_path_from_spec_dir, target_path)
  local_fixtures_dir = get_abolute_path_from_spec_dir(local_path_from_spec_dir)
  LitmusHelper.instance.run_shell("rm -rf #{target_path}")
  LitmusHelper.instance.bolt_upload_file(local_fixtures_dir, target_path)
end

def get_abolute_path_from_spec_dir(rel_path)
  File.join(File.dirname(__FILE__), rel_path)
end

def setup_test_api_endpoint
  api_config = hash_from_fixture_yaml_file('/acceptance/opn-cli/conf.yaml')
  pp_setup = <<-MANIFEST
    opnsense_device { 'opnsense-test.device.com':
      url        => '#{api_config['url']}',
      api_key    => '#{api_config['api_key']}',
      api_secret => Sensitive('#{api_config['api_secret']}'),
      timeout    => #{api_config['timeout']},
      ssl_verify => #{api_config['ssl_verify']},
      ca         => '#{api_config['ca']}',
      ensure     => 'present',
    }
  MANIFEST
  LitmusHelper.instance.apply_manifest(pp_setup, catch_failures: true)
end

def hash_from_fixture_yaml_file(fixture_path)
  fixture_yaml_path = File.join(File.dirname(__FILE__), 'fixtures', fixture_path)
  yaml_file = File.read(fixture_yaml_path)
  YAML.safe_load(yaml_file)
end

def teardown_test_api_endpoint
  pp_cleanup = <<-MANIFEST
    opnsense_device { 'opnsense-test.device.com':
        ensure     => 'absent',
    }
  MANIFEST
  LitmusHelper.instance.apply_manifest(pp_cleanup, catch_failures: true)
end

def build_opn_cli_cmd(cmd)
  env_vars = 'LC_ALL=en_US.utf8 '
  base_cmd = 'opn-cli -c /root/.puppet-opnsense/opnsense-test.device.com-config.yaml '
  env_vars + base_cmd + cmd
end

RSpec.configure do |c|
  c.before :suite do
    vmhostname = LitmusHelper.instance.run_shell('hostname').stdout.strip
    vmipaddr = LitmusHelper.instance.run_shell("ip route get 8.8.8.8 | awk '{print $NF; exit}'").stdout.strip
    if os[:family] == 'redhat'
      vmipaddr = LitmusHelper.instance.run_shell("ip route get 8.8.8.8 | awk '{print $7; exit}'").stdout.strip
    end
    vmos = os[:family]
    vmrelease = os[:release]

    puts "Running acceptance test on #{vmhostname} with address #{vmipaddr} and OS #{vmos} #{vmrelease}"

    puts 'Setup dependencies for test'
    install_test_dependencies

    puts 'Deploying fixtures to /fixtures'
    deploy_fixtures('/fixtures/acceptance', '/fixtures')
  end
end
