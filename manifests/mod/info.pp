# == Class: apache::mod::info
#
# Include mod_info support
#
# === Todo:
#
# TODO: Update documentation
# TODO: LoadModule support
#
class apache::mod::info (
  $notify_service = undef,
  $ensure         = 'present',
) {

  apache::config::loadmodule {'info':
    ensure         => $ensure,
    notify_service => $notify_service,
  }

}
