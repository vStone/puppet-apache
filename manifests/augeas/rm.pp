# == Definition: apache::augeas::rm
#
# Description of apache::augeas::rm
#
# === Parameters:
#
# $param::   description of parameter. default value if any.
#
# === Actions:
#
# Describe what this class does. What gets configured and how.
#
# === Requires:
#
# Requirements. This could be packages that should be made available.
#
# === Sample Usage:
#
# === Todo:
#
# TODO: Update documentation
#
define apache::augeas::rm (
  $value = undef,

) {

  require apache::params

  Augeas {
    lens    => 'Httpd.lns',
    incl    => $::apache::params::config_file,
    context => "/files${::apache::params::config_file}",
  }

  case $value {

    undef: {
      augeas {"apache-augeas-rm-${name}":
        changes => "rm directive[ . = '${name}']",
      }
    }
    default: {
      augeas {"apache-augeas-rm-${name}-${value}":
        changes => "rm directive[ . = '${name}' and arg = '${value}']",
      }
    }

  }


}

