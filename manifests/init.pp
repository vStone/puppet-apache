# = Class: apache
#
#
# == Todo:
#
# TODO: Update documentation
#
class apache (
 $defaults = true
) {

  include apache::module
  include apache::packages
  include apache::setup
  include apache::service

  Class['apache::packages'] ->
  Class['apache::setup'] ->
  Class['apache::service']

  case $::puppetversion {
    /^2.6/:  { require puppetlabs-create_resources }
    default: { }
  }

  if $defaults {
    apache::listen {'80': }
    apache::namevhost {'80': }
  }

}
