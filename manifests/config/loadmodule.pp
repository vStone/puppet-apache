# = Definition: apache::config::loadmodule
#
# Description of apache::config::loadmodule
#
# == Parameters:
#
#
# == Actions:
#
# Describe what this class does. What gets configured and how.
#
# == Requires:
#
# Requirements. This could be packages that should be made available.
#
# == Sample Usage:
#
# == Todo:
#
# TODO: Update documentation
#
define apache::config::loadmodule (
  $module   = "${name}_module",
  $ensure   = 'present',
  $file     = "mod_${name}.so",
  $path     = undef,
  $config   = undef
) {

  require apache::params

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      ## DEBIAN / UBUNTU specific module loading.

      file {"apache-config-loadmodule-debian-${name}":
        path   => "${apache::params::config_dir}/mods-enabled/${name}.load",
        target => "../mods-available/${name}.load",
      }

      case $ensure {
        default,'present',true: {
          File["apache-config-loadmodule-debian-${name}"] {
            ensure => 'link',
          }
        }
        'absent',false: {
          File["apache-config-loadmodule-debian-${name}"] {
            ensure => 'absent',
          }
        }
      }
    }
    default: {
      ## By default we alter the main configuration file by using augeas.

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

      $modfile = $path ? {
        undef   => "${::apache::params::module_root}/${file}",
        default => "${path}/${file}",
      }

      case $ensure {
        default,'present',true: {

          augeas {"apache-config-loadmodule-update-${name}":
            changes => "set directive[ . = 'LoadModule' and arg[1] = '${module}']/arg[2] '${modfile}'",
            onlyif  => "match directive[ . = 'LoadModule' and arg[1] = '${module}'] size > 0",
          }
          augeas {"apache-config-loadmodule-insert-${name}":
            changes => [
              'set directive[. = "LoadModule"][last() + 1] "LoadModule"',
              "set directive[. = 'LoadModule' ][last()]/arg[1] ${module}",
              "set directive[. = 'LoadModule' ][last()]/arg[2] ${modfile}",
              ],
              onlyif  => "match directive[ . = 'LoadModule' and arg[1] = '${module}'] size == 0",
          }
        }
        'absent': {
          augeas {"apache-config-loadmodule-rm-${name}":
            changes => "rm directive[. = 'LoadModule' and arg[1] = '${module}']",
          }
        }
      } ## end case ensure
    }
  } ## end case operatingsystem

}

