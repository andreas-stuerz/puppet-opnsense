# Example: Manage a single opnsense firewall with a running puppet agent
# Install the puppet agent with the opnsense plugin: sysutils/puppet-agent
class { 'opnsense':
  devices => {
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
      nodeexporter => {
        enabled        => true,
        listen_address => '192.168.1.1',
        listen_port    => '9200',
        cpu            => false,
        exec           => false,
        filesystem     => false,
        loadavg        => false,
        meminfo        => false,
        netdev         => false,
        time           => false,
        devstat        => false,
        interrupts     => true,
        ntp            => true,
        zfs            => true,
      },
      'ensure'     => 'present',
    },
  },
  aliases => {
    'my_http_ports_local' => {
      'devices'     => ['localhost'],
      'type'        => 'port',
      'content'     => ['80', '443'],
      'description' => 'example local http ports',
      'enabled'     => true,
    },
  },
  rules   => {
    'allow all from lan' => {
      'devices'   => ['localhost'],
      'sequence'  => '1',
      'action'    => 'pass',
      'interface' => ['lan'],
    },
  },
}
