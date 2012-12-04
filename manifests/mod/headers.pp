# == Class: apache::mod::headers
#
# Include mod_headers support
#
# === Todo:
#
# TODO: Update documentation
# TODO: LoadModule support
#
class apache::mod::headers (
  $notify_service = undef
) {

  apache::config::loadmodule{'headers': }

}
