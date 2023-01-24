# client1.example.com
class { 'opnsense::client::firewall':
  aliases => {
    'client1_example_com'     => {
      'devices'     => ['fw01.example.de'],
      'type'        => 'host',
      'content'     => ['client1.example.com'],
      'description' => 'client.example.com alias',
      'enabled'     => true,
      'ensure'      => present,
    },
    'client1_dmz_example_com' => {
      'devices'     => ['fw01.dmz.example.de'],
      'type'        => 'host',
      'content'     => ['client1.dmz.example.com'],
      'description' => 'client.dmz.example.com alias',
      'enabled'     => true,
      'ensure'      => present,
    },
  },
  rules   => {
    'allow https from lan to client1.example.com' => {
      'devices'          => ['fw01.example.de'],
      'sequence'         => '100',
      'action'           => 'pass',
      'interface'        => ['lan'],
      'protocol'         => 'TCP',
      'destination_net'  => 'client1_example_com',
      'destination_port' => 'https',
      'ensure'           => present,
    },
    'allow https from wan to client1.example.com' => {
      'devices'          => ['fw01.dmz.example.de'],
      'sequence'         => '100',
      'action'           => 'pass',
      'interface'        => ['lan'],
      'protocol'         => 'TCP',
      'destination_net'  => 'client1_dmz_example_com',
      'destination_port' => 'https',
      'ensure'           => present,
    },
  },
}
