# @summary Automate opnsense firewalls
#
# Automate opnsense firewalls
#
# @param devices
#   The devices that wil be managed by this class
# @param api_manager_prefix
#   Prefix that will be added to the description fields for non exported resource items
# @param manage_resources
#   When true, it will export resources to something like puppetdb.
#   When set to true, you'll need to configure 'storeconfigs' to make
#   this happen. Default is set to false, as not everyone has this
#   enabled.
# @param required_plugins
#   The required opnsense plugins to support all features.
# @param firewall
#   Configured the opnsense firewall.
# @param haproxy
#   Configured the opnsense haproxy loadbalancer.
# @param manage_ca
#   When true, the CA file used by opn-cli will be managed to ensure that
#   the communication to the OPNsense API is possible.
# @param ca_content
#   A string containing a CA certificate that should be written to the
#   file specified in `$ca_file`.
# @param ca_file
#   The absolute path to the CA file that should be used by opn-cli.
# @param use_system_ca
#   This instructs opn-cli to use the system-wide installed CA certificates
#   when verifying the connection to the OPNsense API.
# @param system_ca_file
#   The absolute path to the system-wide CA certificate file.
# @param opncli_configdir
#   The config directory used by opn-cli.
#
# @example
#   class { 'opnsense':
#     devices => {
#       "localhost" => {
#         "url"        => 'https://127.0.0.1/api',
#         "api_key"    => '3T7LyQbZSXC/WN56qL0LyvLweNICeiTOzZ2JifNAvlrL+BW8Yvx7WSAUS4xvmLM/BE7xVVtv0Mv2QwNm',
#         "api_secret" => '2mxXt++o5Mmte3sfNJsYxlm18M2t/wAGIAHwmWoe8qc15T5wUrejJQUd/sfXSGnAG2Xk2gqMf8FzHpT2',
#         "ssl_verify" => true,
#         "timeout"    => 60,
#         "ca"         => '~/.opn-cli/ca.pem',
#         "plugins"    => {
#           "os-helloworld" => {}
#         }
#       }
#     },
#     firewall => {
#       aliases => {
#         "my_http_ports_local" => {
#           "devices"     => ["localhost"],
#           "type"        => "port",
#           "content"     => ["80", "443"],
#           "description" => "example local http ports",
#           "enabled"     => true,
#           "ensure"      => present
#         },
#       },
#       rules  => {
#         "allow all from lan and wan" => {
#           "devices"   => ["localhost"],
#           "sequence"  => "1",
#           "action"    => "pass",
#           "interface" => ["lan", "wan"],
#           "ensure"    => present
#         }
#       }
#     },
#     haproxy => {
#       servers  => {
#         "server1" => {
#           "devices"     => ["localhost"],
#           "description" => "first local server",
#           "address"     => "127.0.0.1",
#           "port"        => "8091",
#         },
#         "server2" => {
#           "devices"   => ["localhost"],
#           "description" => "second local server",
#           "address"     => "127.0.0.1",
#           "port"        => "8092",
#         },
#       },
#       backends => {
#         "localhost_backend" => {
#           "devices"        => ["localhost"],
#           "description"    => "local server backend",
#           "mode"           => "http",
#           "linked_servers" => ["server1", "server2"],
#         }
#       },
#       frontends => {
#         "localhost_frontend" => {
#           "devices"           => ["localhost"],
#           "description"       => "local frontend",
#           "bind"              => "127.0.0.1:8090",
#           "ssl_enabled"       => true,
#           "ssl_certificates"  => ["60cc4641eb577"],
#           "default_backend"   => "localhost_backend",
#         }
#       },
#     }
#   }
#
class opnsense (
  Hash $devices,
  String $api_manager_prefix,
  Boolean $manage_resources,
  Hash $required_plugins,
  Hash $firewall,
  Hash $haproxy,
  Boolean $manage_ca,
  Stdlib::Absolutepath $ca_file,
  Boolean $use_system_ca,
  Stdlib::Absolutepath $system_ca_file,
  Stdlib::Absolutepath $opncli_configdir,
  Optional[String] $ca_content,
){
  if $manage_ca {
    file { 'Create opn-cli config directory':
      ensure => directory,
      path   => $opncli_configdir,
    }
    case $use_system_ca {
      true: {
        file { 'Symlink opn-cli CA file to system-wide CA certificates':
          ensure => link,
          path   => $ca_file,
          target => $system_ca_file,
        }
      }
      default: {
        if !empty($ca_content) {
          file { 'Create opn-cli CA file with custom CA content':
            ensure  => file,
            path    => $ca_file,
            content => $ca_content,
          }
        }
      }
    }
  }

  $devices.each |$device_name, $device_conf| {
    # generate devices configurations
    $device_conf_filtered = delete($device_conf, ['plugins'])
    if !empty($device_conf_filtered) {
      opnsense_device { $device_name:
        * => $device_conf_filtered
      }
    }

    # install required and individual plugins on device
    $device_plugins = if $device_conf['plugins'] { $device_conf['plugins'] } else { {} }
    $plugins_to_install = $device_plugins + $required_plugins
    $plugins_to_install.each |$plugin_name, $plugin_options| {
      opnsense_plugin { $plugin_name:
        device => $device_name,
        *      => $plugin_options,
      }
    }

    # firewall aliases
    $firewall['aliases'].map |$alias_name, $alias_options| {
      if $device_name in $alias_options['devices'] {
        $alias_options_filtered = delete($alias_options, ['devices', 'description'])
        opnsense_firewall_alias { "${alias_name}@${device_name}":
          description => "${api_manager_prefix}${alias_options['description']}",
          *           => $alias_options_filtered,
        }
      }
    }

    # firewall rules
    $firewall['rules'].map |$rule_name, $rule_options| {
      if $device_name in $rule_options['devices'] {
        $rule_options_filtered = delete($rule_options, ['devices'])
        opnsense_firewall_rule { "${api_manager_prefix}${rule_name}@${device_name}":
          * => $rule_options_filtered,
        }
      }
    }

    # haproxy servers
    $haproxy['servers'].map |$server_name, $server_options| {
      if $device_name in $server_options['devices'] {
        $server_options_filtered = delete($server_options, ['devices', 'description'])
        opnsense_haproxy_server { "${server_name}@${device_name}":
          description => "${api_manager_prefix}${server_options['description']}",
          *           => $server_options_filtered,
        }
      }
    }

    # haproxy backends
    $haproxy['backends'].map |$backend_name, $backend_options| {
      if $device_name in $backend_options['devices'] {
        $backend_options_filtered = delete($backend_options, ['devices', 'description'])
        opnsense_haproxy_backend { "${backend_name}@${device_name}":
          description => "${api_manager_prefix}${backend_options['description']}",
          *           => $backend_options_filtered,
        }
      }
    }

    # haproxy frontends
    $haproxy['frontends'].map |$frontend_name, $frontend_options| {
      if $device_name in $frontend_options['devices'] {
        $frontend_options_filtered = delete($frontend_options, ['devices', 'description'])
        opnsense_haproxy_frontend { "${frontend_name}@${device_name}":
          description => "${api_manager_prefix}${frontend_options['description']}",
          *           => $frontend_options_filtered,
        }
      }
    }

    if $manage_resources {
      Opnsense_firewall_alias <<| tag == $device_name |>>
      Opnsense_firewall_rule <<| tag == $device_name |>>
      Opnsense_haproxy_server <<| tag == $device_name |>>
      Opnsense_haproxy_backend <<| tag == $device_name |>>
      Opnsense_haproxy_frontend <<| tag == $device_name |>>
    }

  }
}
