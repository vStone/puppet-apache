# = Class: apache
#
# Setup apache for usage.
#
# == Parameters:
#
# $defaults::   With defaults, we will define a default namevhost on port 80.
#               This includes the apache::listen and apache::namevhost directive.
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
