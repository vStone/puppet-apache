# == Class: apache::mod::status
#
# Include mod_status support
#
# === Todo:
#
# TODO: Update documentation
# TODO: LoadModule support
#
class apache::mod::status (
  $notify_service = undef,
  $ensure         = 'present',
  $extendedstatus = false
) {

  $_extendedstatus = $extendedstatus ? {
    true    => 'On',
    false   => 'Off',
    undef   => 'Off',
    default => $extendedstatus,
  }

  apache::config::loadmodule {'status':
    ensure         => $ensure,
    notify_service => $notify_service,
  }
  apache::augeas {'ExtendedStatus':
    ensure         => $ensure,
    notify_service => $notify_service,
    value          => $_extendedstatus
  }

}
