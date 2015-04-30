# == Class: apache::packages
#
# Installs the required packages.
#
# Optionally, depending on the configuration in apache::params,
# also installs the devel package and/or ssl support.
#
# === Parmaeters:
#
# [*notify_service*]
#   Should we restart the apache service after an upgrade.
#
class apache::packages (
  $notify_service = undef
) {

  require apache::params

  $notifyservice = $notify_service ? {
    undef   => $::apache::params::notify_service,
    default => $notify_service,
  }

  if $notifyservice {
    Package {
      notify  => Service['apache'],
    }
  }

  package {$::apache::params::package:
    ensure  => installed,
    alias   => 'apache',
  }

  if $::apache::params::devel == true {
    package {$::apache::params::package_devel:
      ensure  => installed,
      alias   => 'apache-devel',
      require => Package['apache'],
    }
  }

  if $::apache::params::ssl == true {
    package {$::apache::params::package_ssl:
      ensure  => installed,
      alias   => 'apache-ssl',
      require => Package['apache'],
    }
  }

}
