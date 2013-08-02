# == Definition: apache::config::loadmodule
#
# Helper definition to load a certain apache module.
# This contains logic to deal with debian-style mods-enabled and
# mods-available forlders.
#
# === Parameters:
#
# [*ensure*]
#   Present or absent.
#
# [*notify_service*]
#   Restart the apache service after adjusting the configuration.
#
# [*module*]
#   Name of the module to load (or remove). This defaults to
#   <name>_module.
#
# [*file*]
#   File name of the module. Defaults to mod_<name>.so
#
# [*path*]
#   Path where module files are located. Defaults to distro specific.
#
# [*config*]
#   Configuration file to operate on. Defaults to distro specific.
#
# === Todo:
#
# TODO: Update documentation
#
define apache::config::loadmodule (
  $notify_service = undef,
  $ensure         = 'present',
  $module         = "${name}_module",
  $file           = "mod_${name}.so",
  $path           = undef,
  $config         = undef
) {

  require apache::params

  $_notify = $notify_service ? {
    undef   => $apache::params::notify_service,
    default => $notify_service,
  }

  case $::osfamily {
    'Debian': {
      ## DEBIAN / UBUNTU specific module loading.
      file {"apache-config-loadmodule-debian-${name}":
        path    => "${apache::params::config_dir}/mods-enabled/${name}.load",
        target  => "../mods-available/${name}.load",
        require => Package[$::apache::params::package],
      }

      Exec {
        path    => ['/usr/bin','/bin'],
        require => Package[$::apache::params::package],
      }
      if $_notify {
        File["apache-config-loadmodule-debian-${name}"] {
          notify => Service['apache']
        }
      }

      case $ensure {
        default,'present',true: {
          File["apache-config-loadmodule-debian-${name}"] { ensure => 'link', }
          exec {"apache-config-loadmodule-debian-exec-${name}-conf":
            creates => "${::apache::params::config_dir}/mods-enabled/${name}.conf",
            command => "ln -sf ../mods-available/${name}.conf ${name}.conf",
            onlyif  => "test -f ${::apache::params::config_dir}/mods-available/${name}.conf",
            cwd     => "${::apache::params::config_dir}/mods-enabled/",
          }

        }
        'absent',false: {
          File["apache-config-loadmodule-debian-${name}"] { ensure => 'absent', }
          exec {"apache-config-loadmodule-debian-exec-${name}-conf":
            command => "rm -f ${name}.conf",
            onlyif  => "test -f ${::apache::params::config_dir}/mods-enabled/${name}.conf",
            cwd     => "${::apache::params::config_dir}/mods-enabled/",
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
            tag     => "loadmodule-${name}",
          }
          augeas {"apache-config-loadmodule-insert-${name}":
            changes => [
              'set directive[. = "LoadModule"][last() + 1] "LoadModule"',
              "set directive[. = 'LoadModule' ][last()]/arg[1] ${module}",
              "set directive[. = 'LoadModule' ][last()]/arg[2] ${modfile}",
            ],
            onlyif  => "match directive[ . = 'LoadModule' and arg[1] = '${module}'] size == 0",
            tag     => "loadmodule-${name}",
          }
        }
        'absent': {
          augeas {"apache-config-loadmodule-rm-${name}":
            changes => "rm directive[. = 'LoadModule' and arg[1] = '${module}']",
            tag     => "loadmodule-${name}",
          }
        }
      } ## end case ensure
      if $_notify {
        Augeas<| tag == "loadmodule-${name}" |> {
          notify => Service['apache'],
        }
      }
    }
  } ## end case operatingsystem

}

