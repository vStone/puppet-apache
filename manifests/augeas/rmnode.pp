# == Definition: apache::augeas::rmnode
#
# Description of apache::augeas::rmnode
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
define apache::augeas::rmnode (
  $type = $name,
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
      augeas {"apache-augeas-rmnode-${name}":
        changes => "rm ${type}",
      }
    }
    default: {
      augeas {"apache-augeas-rm-${name}-${value}":
        changes => "rm *[label() = '${type}' and arg = '${value}']",
      }
    }

  }


}

