# == Definition: apache::vhost::mod::advertise
#
# This advertise is an example on how to add your own vhost mod.
#
# === Parameters:
#
# Some basic parameters that are always present in a module are not
# documented. See the apache::vhost::mod::dummy for an explanation on them.
#
# [*enable_mcpm_receive*]
#   Defaults to 'true'
#
# [*server_advertise*]
#   Defaults to undefined.
#
# [*group*]
#   Defaults to undefined.
#
# [*frequency*]
#   Defaults to undefined.
#
# [*bind_address*]
#   Defaults to undefined.
#
# [*security_key*]
#   Defaults to undefined.
#
# === Todo:
#
# TODO: Update documentation
#
define apache::vhost::mod::advertise (
  $vhost,
  $notify_service = undef,
  $ensure         = 'present',
  $ip             = undef,
  $port           = '80',
  $docroot        = undef,
  $order          = undef,
  $_automated     = false,
  $_header        = true,
  $comment        = undef,
  $content        = '',

  $enable_mcpm_receive = true,
  $server_advertise    = undef,
  $group               = undef,
  $frequency           = undef,
  $security_key        = undef,
  $bind_address        = undef
) {



  case $server_advertise {
    true,false,undef: {}
    default: {
      fail('server_advertise: allowed values: true,false or leave undefined.')
    }
  }
  case $group {
    /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(:[0-9]+)?$/: {}
    undef: {}
    default: {
      fail('group: value must be either an IP or IP:PORT.')
    }
  }
  case $frequency {
    /^[0-9]+(\.[0-9]+)$/: {}
    undef: {}
    default: {
      fail('frequency: allowed value must be <seconds>(.<miliseconds>).')
    }
  }
  case $bind_address {
    /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:[0-9]+$/: {}
    undef: {}
    default: {
      fail('bind_address: value must be an IP:PORT.')
    }
  }

  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/advertise.erb')

  apache::sys::modfile {$title:
    ensure         => $ensure,
    vhost          => $vhost,
    ip             => $ip,
    port           => $port,
    nodepend       => $_automated,
    content        => $definition,
    order          => $order,
    notify_service => $notify_service,
  }
}

