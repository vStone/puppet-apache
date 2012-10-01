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
  $key    = $name,
  $value  = undef,
  $config = undef
) {

  require apache::params

  $config_file = $config ? {
    undef   => $::apache::params::config_file,
    default => $config,
  }

  Augeas {
    lens    => 'Httpd.lns',
    incl    => $config_file,
    context => "/files${config_file}",
  }

  case $value {

    undef: {
      augeas {"apache-augeas-rm-${name}":
        changes => "rm directive[ . = '${key}']",
      }
    }
    default: {
      augeas {"apache-augeas-rm-${name}-${value}":
        changes => "rm directive[ . = '${key}' and arg = '${value}']",
      }
    }

  }


}

