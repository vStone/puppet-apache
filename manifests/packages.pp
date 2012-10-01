# == Class: apache::packages
#
# Installs the required packages.
#
# Optionally, depending on the configuration in apache::params,
# also installs the devel package and/or ssl support.
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

  @package {$::apache::params::package:
    ensure  => installed,
    alias   => 'apache',
  }

  @package {$::apache::params::package_devel:
    ensure  => installed,
    alias   => 'apache-devel',
    require => Package['apache'],
  }

  @package {$::apache::params::package_ssl:
    ensure  => installed,
    alias   => 'apache-ssl',
    require => Package['apache'],
  }

  realize(Package[$::apache::params::package])

  if $::apache::params::devel == true {
    realize(Package[$::apache::params::package_devel])
  }

  if $::apache::params::ssl == true {
    realize(Package[$::apache::params::package_ssl])
  }

}
