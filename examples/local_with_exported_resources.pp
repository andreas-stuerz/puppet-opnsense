# Example: Manage a single opnsense firewall configure
# Install the puppet agent with the opnsense plugin: sysutils/puppet-agent
class { 'opnsense':
  devices          => {
    'localhost' => {
      'url'        => 'https://127.0.0.1/api',
      'api_key'    => 'your_api_key',
      'api_secret' => 'your_api_secret',
      'ssl_verify' => true,
      'timeout'    => 60,
      'ca'         => '~/.opn-cli/ca.pem',
      'plugins'    => {
        'os-helloworld' => {},
      },
    },
  },
  aliases          => {
    'my_http_ports_local' => {
      'devices'     => ['localhost'],
      'type'        => 'port',
      'content'     => ['80', '443'],
      'description' => 'example local http ports',
      'enabled'     => true,
    },
  },
  rules            => {
    'allow all from lan and wan' => {
      'devices'   => ['localhost'],
      'sequence'  => '1',
      'action'    => 'pass',
      'interface' => ['lan', 'wan'],
    },
  },
  manage_resources => true,
}

class { 'opnsense::client::firewall':
  aliases => {
    'http_ports_from_client' => {
      'devices'     => ['localhost'],
      'type'        => 'port',
      'content'     => ['80', '443'],
      'description' => '',
      'enabled'     => true,
      'ensure'      => present,
    },
  },
  rules   => {
    'allow all from lan and wan' => {
      'devices'   => ['localhost'],
      'sequence'  => '1',
      'action'    => 'pass',
      'interface' => ['lan', 'wan'],
      'ensure'    => present,
    },
  },
}
