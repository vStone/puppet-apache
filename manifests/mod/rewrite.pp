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
  $notify_service = undef
) {

  require apache::params

  apache::config::loadmodule {'rewrite': }

}
