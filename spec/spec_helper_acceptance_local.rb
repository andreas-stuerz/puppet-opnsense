# frozen_string_literal: true

require 'singleton'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

# load hash from a yaml file under fixtures
def hash_from_fixture_yaml_file(fixture_path)
  fixture_yaml_path = File.join(File.dirname(__FILE__), 'fixtures', fixture_path)
  yaml_file = File.read(fixture_yaml_path)
  YAML.safe_load(yaml_file)
end

# create a file on the test machine
def create_remote_file(name, dest_filepath, file_content)
  Tempfile.open name do |tempfile|
    File.open(tempfile.path, 'w') { |file| file.puts file_content }
    LitmusHelper.instance.bolt_upload_file(tempfile.path, dest_filepath)
  end
end

def deploy_fixtures(target_dir = '/fixtures')
  local_fixtures_dir = File.join(File.dirname(__FILE__), '/fixtures/acceptance')
  LitmusHelper.instance.run_shell("rm -rf #{target_dir}")
  LitmusHelper.instance.bolt_upload_file(local_fixtures_dir, target_dir)
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

    # install dependencies
    pp_setup = <<-MANIFEST
          $packages = [
            'python3',
            'python3-pip',
          ]
          $pip_packages = [
            'ruamel.yaml',
            'Jinja2'
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
end
