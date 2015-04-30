# == Definition: apache::augeas::rmnode
#
# Remove a node from the apache configuration using augeas.
#
# === Parameters:
#
# [*type*]
#   The apache type to remove.
#
# [*value*]
#   Optionally, the specific value of a certain type to remove.
#
# [*config*]
#   The configuration file to operate on.
#
# === Sample Usage:
#
#   apache::augeas::rmnode {'remove_ifmodule_block'
#     type  => 'IfModule',
#     value => 'mod_something.c',
#   }
#
define apache::augeas::rmnode (
  $type   = $name,
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
    require => Package['apache'],
    before  => Service['apache'],
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

