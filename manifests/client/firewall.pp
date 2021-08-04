# @summary Use exported resources to collect firewall configurations from clients.
#
# This will create resources for firewall configurations into puppetdb
# for automatically configuring them on one or more opnsense firewall.
#
# @param aliases
#   Firewall aliases that are associated with this client.
# @param rules
#   Firewall rules that are associated with this client.
#
# @example
#   class { 'opnsense::client::firewall':
#     aliases => {
#       "my_http_ports_from_client" => {
#         "devices"     => ["localhost"],
#         "type"        => "port",
#         "content"     => ["80", "443"],
#         "description" => "example local http ports",
#         "enabled"     => true,
#         "ensure"      => present
#       },
#     },
#     rules => {
#       "allow all from lan and wan" => {
#         "devices"   => ["localhost"],
#         "sequence"  => "1",
#         "action"    => "pass",
#         "interface" => ["lan", "wan"],
#         "ensure"      => present
#       }
#     }
#   }
#
class opnsense::client::firewall (
  Hash $aliases,
  Hash $rules,
){
  $aliases.map |$alias_name, $alias_options| {
    $alias_options['devices'].each |$device_name| {
      $alias_options_filtered = delete($alias_options, ['devices', 'description'])
        @@opnsense_firewall_alias { "${alias_name}@${device_name}":
          description => "${::fqdn} - ${alias_options['description']}",
          *           => $alias_options_filtered,
          tag         => $device_name,
        }
    }
  }

  $rules.map |$rule_name, $rule_options| {
    $rule_options['devices'].each |$device_name| {
      $rule_options_filtered = delete($rule_options, ['devices', 'description'])
      @@opnsense_firewall_rule { "${::fqdn} - ${rule_name}@${device_name}":
        *   => $rule_options_filtered,
        tag => $device_name,
      }
    }
  }

}
