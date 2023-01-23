# @summary Use exported resources to collect haproxy configurations from clients.
#
# This will create resources for haproxy configurations into puppetdb
# for automatically configuring them on one or more opnsense firewall.
#
# @param servers
#   HaProxy servers that are associated with this client.
# @param backends
#   HaProxy backends that are associated with this client.
# @param frontends
#   Firewall rules that are associated with this client.
#
# @example
#   class { 'opnsense::client::haproxy':
#     servers  => {
#       "server1" => {
#         "devices"     => ["localhost"],
#         "description" => "first local server",
#         "address"     => "127.0.0.1",
#         "port"        => "8091",
#       },
#       "server2" => {
#         "devices"     => ["localhost"],
#         "description" => "second local server",
#         "address"     => "127.0.0.1",
#         "port"        => "8092",
#       },
#     },
#     backends => {
#       "localhost_backend" => {
#         "devices"        => ["localhost"],
#         "description"    => "local server backend",
#         "mode"           => "http",
#         "linked_servers" => ["server1", "server2"],
#       }
#     },
#     frontends => {
#       "localhost_frontend" => {
#         "devices"           => ["localhost"],
#         "description"       => "local frontend",
#         "bind"              => "127.0.0.1:8090",
#         "ssl_enabled"       => true,
#         "ssl_certificates"  => ["60cc4641eb577"],
#         "default_backend"   => "localhost_backend",
#       }
#     },
#   }
#
class opnsense::client::haproxy (
  Hash $servers,
  Hash $backends,
  Hash $frontends,
) {
  $servers.map |$server_name, $server_options| {
    $server_options['devices'].each |$device_name| {
      $server_options_filtered = delete($server_options, ['devices', 'description'])
      @@opnsense_haproxy_server { "${server_name}@${device_name}":
        description => "${facts['networking']['fqdn']} - ${server_options['description']}",
        *           => $server_options_filtered,
        tag         => $device_name,
      }
    }
  }

  $backends.map |$backend_name, $backend_options| {
    $backend_options['devices'].each |$device_name| {
      $backend_options_filtered = delete($backend_options, ['devices', 'description'])
      @@opnsense_haproxy_backend { "${backend_name}@${device_name}":
        description => "${facts['networking']['fqdn']} - ${backend_options['description']}",
        *           => $backend_options_filtered,
        tag         => $device_name,
      }
    }
  }

  $frontends.map |$frontend_name, $frontend_options| {
    $frontend_options['devices'].each |$device_name| {
      $frontend_options_filtered = delete($frontend_options, ['devices', 'description'])
      @@opnsense_haproxy_frontend { "${frontend_name}@${device_name}":
        description => "${facts['networking']['fqdn']} - ${frontend_options['description']}",
        *           => $frontend_options_filtered,
        tag         => $device_name,
      }
    }
  }
}
