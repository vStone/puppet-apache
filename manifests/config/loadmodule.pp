# = Definition: apache::config::loadmodule
#
# Description of apache::config::loadmodule
#
# == Parameters:
#
# $param::   description of parameter. default value if any.
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
  $path     = undef
) {

  require apache::params

  Augeas {
    lens    => 'Httpd.lns',
    incl    => $::apache::params::config_file,
    context => "/files${::apache::params::config_file}",
  }

  $modfile = $path ? {
    undef   => "${::apache::params::module_root}/${file}",
    default => "${path}/${file}",
  }

  notify {"apache-config-loadmodule-${name}":
    message => "
    name: ${name}
    module: ${module}
    file: ${file}
    modfile: ${modfile}
    ",
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
        onlyif => "match directive[ . = 'LoadModule' and arg[1] = '${module}'] size == 0",
      }
    }
    'absent': {

      augeas {"apache-config-loadmodule-rm-${name}":
        changes => "rm directive[. = 'LoadModule' and arg[1] = '${module}']",
      }

    }

  }

}

