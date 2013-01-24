# == Definition: apache::augeas::set
#
# Description of apache::augeas::set
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
define apache::augeas::set (
  $value,
  $config         = undef,
  $notify_service = undef,
) {

  require apache::params
  $_notify = $notify_service ? {
    undef   => $apache::params::notify_service,
    default => $notify_service,
  }

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

  # Update if it exists
  augeas {"apache-augeas-set-update-${name}":
    changes => "set directive[ . = '${name}']/arg ${value}",
    onlyif  => "match directive[ . = '${name}'] size > 0",
  }

  # Create if it does not exist.
  augeas {"apache-augeas-set-insert-${name}":
    changes => template('apache/augeas/set-insert.erb'),
    onlyif  => "match directive[ . = '${name}'] size == 0",
  }

  if $_notify {
    Augeas["apache-augeas-set-update-${name}"] { notify => Service['apache'] }
    Augeas["apache-augeas-set-insert-${name}"] { notify => Service['apache'] }
  }

}

