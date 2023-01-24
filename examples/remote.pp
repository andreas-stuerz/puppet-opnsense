# Example for using a linux host managing mulitple opnsense firewalls
# See remote_client.pp for an example client configuration
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

class { 'opnsense':
  devices          => {
    'fw01.example.de'     => {
      'url'        => 'https://fw01.example.de/api',
      'api_key'    => 'key_1',
      'api_secret' => 'secret_1',
      'ssl_verify' => true,
      'timeout'    => 60,
      'ca'         => '~/.opn-cli/ca1.pem',
      'plugins'    => {
        'os-acme-client' => {},
        'os-bind'        => {},
      },
    },
    'fw01.dmz.example.de' => {
      'url'        => 'https://fw01.dmz.example.de/api',
      'api_key'    => 'key_2',
      'api_secret' => 'secret_2',
      'ssl_verify' => true,
      'timeout'    => 60,
      'ca'         => '~/.opn-cli/ca2.pem',
      'plugins'    => {
        'os-haproxy' => {},
      },
    },
  },
  aliases          => {
    'my_http_ports_remote' => {
      'devices'     => ['fw01.example.de', 'fw01.dmz.example.de'],
      'type'        => 'port',
      'content'     => ['80', '443'],
      'description' => 'example remote http ports',
      'enabled'     => true,
    },
  },
  rules            => {
    'allow all from lan and wan' => {
      'devices'   => ['fw01.example.de', 'fw01.dmz.example.de'],
      'sequence'  => '1',
      'action'    => 'pass',
      'interface' => ['lan', 'wan'],
    },
  },
  manage_resources => true,
}
