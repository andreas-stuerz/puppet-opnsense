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
          api_url    => 'https://opnsense.example.com/api',
          api_key    => 'your_api_key',
          api_secret => Sensitive('your_api_secret'),
          timeout    => 60,
          ssl_verify => true,
          ca         => /path/to/ca.pem',
          ensure     => 'present',
        }
      MANIFEST
      it 'works without errors' do
        apply_manifest(pp, catch_failures: true)
      end

      it 'writes the yaml configuration file with correct values' do

      end
    end

  end


end
