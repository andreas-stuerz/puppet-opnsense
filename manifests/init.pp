# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include opnsense
class opnsense (
  Hash $devices,
  String $api_manager_prefix,
  Boolean $manage_resources,
  Array $required_plugins,
  Hash $aliases,
  Hash $rules,
){

  # install requirements

  # install plugins


  # generate devices configuration

  # collect rules for all configured device
  if $manage_resources {
    # for each device
      # collect and build firewall aliases
      Opnsense_firewall_alias <<| tag == "${device}" |>>


      # collect and build firewall rules
      Opnsense_firewall_rule <<| tag == "${device}" |>>
  }



}
