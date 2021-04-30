# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_device',
  docs: <<-EOS,
  @summary
    Manage an OPNsense device access.
  @see
    https://docs.opnsense.org/development/how-tos/api.html#use-the-api
  @example
  opnsense_device { 'foo.example.com':
    url        => 'https://foo.example.com/api',
    api_key    => 'your_api_key',
    api_secret => Sensitive('your_api_secret'),
    timeout    => 60,
    ssl_verify => true,
    ca         => '/path/to/ca.pem',
    ensure     => 'present',
  }
  
  This type provides Puppet with the capabilities to manage OPNSense device access data.
EOS
  features: ['simple_get_filter', 'canonicalize'],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
        #type: 'Pattern[/\A[0-9A-Za-z.-]+/]',
      type: 'String',
      desc: 'The name of the OPNsense device you want to manage.',
      behaviour: :namevar,
    },
    url: {
        type: 'String',
        desc: 'The api url of the OPNsense device.',
    },
    api_key: {
        type: 'String',
        desc: 'The api key from the generated key/secret pair.',
    },
    api_secret: {
        type: 'Sensitive[String]',
        desc: 'The api secret from the generated key/secret pair.',
    },
    timeout: {
        type: 'Integer',
        desc: 'The timeout for API calls in seconds.',
        default: 60,
    },
    ssl_verify: {
        type: 'Boolean',
        desc: 'The timeout for API calls in seconds.',
        default: true,
    },
    ca: {
        type: 'Optional[String]',
        desc: 'The path to the ca bundle file for ssl verification.',
    },
  },
)
