require 'spec_helper_acceptance'

describe 'opnsense_plugin' do
  before(:all) do
    setup_test_api_endpoint()
  end
  after(:all) do
   teardown_test_api_endpoint()
  end

  context 'for opnsense-test.device.com' do
    describe 'add plugin os-acme-client' do
      pp = <<-MANIFEST
        opnsense_plugin { 'os-acme-client':
          device => 'opnsense-test.device.com',
          ensure => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      describe command(opn_cli_cmd('plugin installed -c name')) do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match %r{os-acme-client} }
      end
    end

    describe 'delete plugin os-acme-client' do
      pp = <<-MANIFEST
        opnsense_plugin { 'os-acme-client':
          device => 'opnsense-test.device.com',
          ensure => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      describe command(opn_cli_cmd('plugin installed -c name')) do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should_not match %r{os-acme-client} }
      end
    end
  end
end
