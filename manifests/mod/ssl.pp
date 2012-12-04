# == Class: apache::mod::ssl
#
# Include mod_ssl support
#
# === Todo:
#
# TODO: Update documentation
# TODO: LoadModule support
#
class apache::mod::ssl (
  $notify_service = undef
) {

  require apache::params

  apache::config::loadmodule {'ssl': }

}
