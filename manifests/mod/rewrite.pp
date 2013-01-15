# == Class: apache::mod::rewrite
#
# Include mod_rewrite support
#
# === Todo:
#
# TODO: Update documentation
# TODO: LoadModule support
#
class apache::mod::rewrite (
  $notify_service = undef,
  $ensure         = 'present',
) {

  apache::config::loadmodule {'rewrite':
    ensure         => $ensure,
    notify_service => $notify_service,
  }

}
