# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include opnsense::firewall::aliases
class opnsense::firewall::aliases (
  Hash $aliases
){
  each $aliases.each || {
    leg opnsense::resources::firewall::alias an mit werten aus dem Hash

  }
}
