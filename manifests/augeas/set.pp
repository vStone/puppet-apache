# = Definition: apache::augeas::set
#
# Description of apache::augeas::set
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
define apache::augeas::set (
  $value,
  $lens = 'Httpd.lns',
  $incl = $::apache::params::config_file
) {

  $context = "/files${incl}"

  Augeas {
    lens    => $lens,
    incl    => $incl,
    context => $context,
  }

  # Update if it exists
  augeas {"apache-augeas-set-update-${name}":
    changes => "set directive[ . = '${name}']/arg ${value}",
    onlyif  => "match directive[ . = '${name}'] size > 0",
  }

  # Create if it does not exist.
  augeas {"apache-augeas-set-insert-${name}":
    changes => [
      'ins directive after *[last()]',
      "set directive[last()] '${name}'",
      "set directive[last()]/arg '${value}'"
    ],
    onlyif  => "match directive[ . = '${name}'] size == 0",
  }

}

