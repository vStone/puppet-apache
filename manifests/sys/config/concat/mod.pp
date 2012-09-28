# == Definition: apache::sys::config::concat::mod
#
# Helper file wrapper for extra mods for a certain vhost.
# This will be added to the vhost configuration using the
# concat module.
#
# === Parameters:
#
# $vhost:
#
# $ensure:
#
#
# === Todo:
#
# TODO: Update documentation
#
define apache::sys::config::concat::mod (
  $vhost,
  $notify_service = undef,
  $ip             = undef,
  $port           = '80',
  $ensure         = 'present',
  $content        = '',
  $nodepend       = false,
  $order          = undef
) {

  ## Get the configured configuration style.
  require apache::params
  require apache::sys::config::concat::params

  case $notify_service {
    undef: {}
    default: {
      warn('Setting the notify_service parameter explicitly for a mod will have no impact using the concat configuration style. This should be configured in the vhost or globally.')
    }
  }

  $fragment_name = "${vhost}_mod_${name}"

  $forder = $order ? {
    undef   => undef,
    default => sprintf('%04d',$order),
  }

  concat::fragment{$fragment_name:
    ensure  => $ensure,
    target  => $vhost,
    content => $content,
    order   => $forder,
  }

}
