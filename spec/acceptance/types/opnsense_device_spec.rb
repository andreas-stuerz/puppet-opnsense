require 'spec_helper_acceptance'

describe 'opnsense_device' do
  before(:all) do
  end
  after(:all) do
  end

  context 'for device opnsense.example.com' do
    describe 'add device configuration' do
      pp = <<-MANIFEST
        opnsense_device { 'opnsense.example.com':
          url        => 'https://opnsense.example.com/api',
          api_key    => 'your_api_key',
          api_secret => Sensitive('your_api_secret'),
          timeout    => 60,
          ssl_verify => true,
          ca         => '/path/to/ca.pem',
          ensure     => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      describe file("/root/.puppet-opnsense/opnsense.example.com-config.yaml") do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match %r{api_key: your_api_key} }
        its(:content) { is_expected.to match %r{api_secret: your_api_secret} }
        its(:content) { is_expected.to match %r{url: https://opnsense.example.com/api} }
        its(:content) { is_expected.to match %r{timeout: 60} }
        its(:content) { is_expected.to match %r{ssl_verify: true} }
        its(:content) { is_expected.to match %r{ca: "/path/to/ca.pem"} }
      end
    end

    describe 'update device configuration' do
      pp = <<-MANIFEST
        opnsense_device { 'opnsense.example.com':
          url        => 'https://opnsense.example.de/api',
          api_key    => 'your_api_key2',
          api_secret => Sensitive('your_api_secret2'),
          timeout    => 40,
          ssl_verify => false,
          ca         => '/path/to/other/ca.pem',
          ensure     => 'present',
        }
      MANIFEST

      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      describe file("/root/.puppet-opnsense/opnsense.example.com-config.yaml") do
        it { is_expected.to be_file }
        its(:content) { is_expected.to match %r{api_key: your_api_key2} }
        its(:content) { is_expected.to match %r{api_secret: your_api_secret2} }
        its(:content) { is_expected.to match %r{url: https://opnsense.example.de/api} }
        its(:content) { is_expected.to match %r{timeout: 40} }
        its(:content) { is_expected.to match %r{ssl_verify: false} }
        its(:content) { is_expected.to match %r{ca: "/path/to/other/ca.pem"} }
      end

    end

    describe 'delete device configuration' do
      pp = <<-MANIFEST
        opnsense_device { 'opnsense.example.com':
          ensure     => 'absent',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      describe file("/root/.puppet-opnsense/opnsense.example.com-config.yaml") do
        it { is_expected.not_to exist }
      end
    end

  end
end
