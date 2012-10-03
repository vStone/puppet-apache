# == Class: apache
#
# Setup apache for usage.
#
# === Parameters:
#
# $defaults::   With defaults, we will define a default namevhost on port 80.
#               This includes apache::listen {'80': }
#               and apache::namevhost {'80': }
#
# === Todo:
#
# TODO: Update documentation
#
class apache (
  $defaults = undef
) {

  require apache::params
  $_defaults = $defaults ? {
    undef   => $::apache::params::defaults,
    default => $defaults,
  }


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

  if $_defaults {
    apache::listen {'80': }
    apache::namevhost {'80': }
  }

}
