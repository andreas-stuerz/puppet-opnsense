# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include opnsense::client::firewall::aliases
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
