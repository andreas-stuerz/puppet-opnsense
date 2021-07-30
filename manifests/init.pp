# @summary Automate opnsense firewalls
#
# Automate opnsense firewalls
#
# @example
#   include opnsense
class opnsense (
  Hash $devices,
  String $api_manager_prefix,
  Boolean $manage_resources,
  Hash $required_plugins,
  Hash $aliases,
  Hash $rules,
){
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

    # local aliases
    $aliases.map |$alias_name, $alias_options| {
      if $device_name in $alias_options['devices'] {
        $alias_options_filtered = delete($alias_options, ['devices', 'description'])
        opnsense_firewall_alias { "${alias_name}@${device_name}":
          description => "${api_manager_prefix}${alias_options['description']}",
          *           => $alias_options_filtered,
        }
      }
    }

    # local rules
    $rules.map |$rule_name, $rule_options| {
      if $device_name in $rule_options['devices'] {
        $rule_options_filtered = delete($rule_options, ['devices'])
        opnsense_firewall_rule { "${api_manager_prefix}${rule_name}@${device_name}":
          * => $rule_options_filtered,
        }
      }
    }

    if $manage_resources {
      Opnsense_firewall_alias <<| tag == $device_name |>>
      Opnsense_firewall_rule <<| tag == $device_name |>>
    }

  }
}
