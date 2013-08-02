# == Definition apache::augeas
#
# Helper definition.
# Delegates to apache::augeas::set and apache::augeas::rm
#
# === Parameters
#
# [*ensure*]
#   Set to present or absent (true / false).
#
# [*value*]
#   Value to set with ensure => present.
#
# [*notify_service*]
#   Should we notify the apache service after the change.
#
# [*config*]
#   Config file to work on.
#
# === Usage:
#
# === Todo:
#
# * TODO: Add usage example.
#
define apache::augeas (
  $value          = undef,
  $ensure         = 'present',
  $notify_service = undef,
  $config         = undef,
) {

  case $ensure {
    true, 'present', default: {
      apache::augeas::set {$name:
        value          => $value,
        config         => $config,
        notify_service => $notify_service,
      }
    }
    false, 'absent': {
      apache::augeas::rm {$name:
        value          => $value,
        config         => $config,
        notify_service => $notify_service
      }
    }
  }

}
