# == Class: apache::mod::ssl
#
# Include mod_ssl support
#
# === Todo:
#
# TODO: Update documentation
#
class apache::mod::ssl (
  $notify_service = undef,
  $ensure         = 'present',
) {

  apache::config::loadmodule {'ssl':
    ensure         => $ensure,
    notify_service => $notify_service,
  }

}
