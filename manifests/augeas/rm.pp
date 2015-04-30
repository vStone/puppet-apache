# == Definition: apache::augeas::rm
#
# Remove a configuration key from the apache configuration.
#
# === Parameters:
#
# [*key*]
#   Key to remove.
#
# [*value*]
#   If defined, only remove the key with this value.
#
# [*config*]
#   The configuration file to operate on.
#
# === Sample Usage:
#
#   apache::augeas::rm {'remove_include_file':
#     key   => 'Include',
#     value => 'somefile.conf',
#   }
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
    require => Package['apache'],
    before  => Service['apache'],
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

