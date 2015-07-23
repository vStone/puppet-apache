# == Class: apache::mod::status
#
# Include mod_status support
#
# === Todo:
#
# TODO: Update documentation
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
  }

  apache::augeas::set {'ExtendedStatus':
    value          => $_extendedstatus,
  }

}
