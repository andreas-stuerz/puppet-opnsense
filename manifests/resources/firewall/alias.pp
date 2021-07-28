# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   opnsense::resources::firewall::alias { 'namevar': }
define opnsense::resources::firewall::alias (
) {
  for each....
  @@opnsense_alias(

  tag => $device
  )
}
