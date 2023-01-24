require 'spec_helper_acceptance'

describe 'opnsense_plugin' do
  context 'for opnsense-test.device.com' do
    describe 'add plugin os-helloworld' do
      pp = <<-MANIFEST
        opnsense_plugin { 'os-helloworld':
          device => 'opnsense-test.device.com',
          ensure => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the plugin as installed via the cli', retry: 3, retry_wait: 10 do
        run_shell(build_opn_cli_cmd('plugin installed -o plain -c name')) do |r|
          expect(r.stdout).to match %r{os-helloworld}
        end
      end
    end

    describe 'delete plugin os-helloworld' do
      pp = <<-MANIFEST
        opnsense_plugin { 'os-helloworld':
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'displays the plugin as unistalled via the cli', retry: 3, retry_wait: 20 do
        run_shell(build_opn_cli_cmd('plugin installed -o plain -c name')) do |r|
          expect(r.stdout).not_to match %r{os-helloworld}
        end
      end
    end
  end
end
