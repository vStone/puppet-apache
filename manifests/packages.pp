# == Class: apache::packages
#
# Installs the required packages.
#
# Optionally, depending on the configuration in apache::params,
# also installs the devel package and/or ssl support.
#
class apache::packages {
  require apache::params

  @package {$::apache::params::package:
    ensure  => installed,
    alias   => 'apache',
    notify  => Service['apache'];
  }
  realize(Package[$::apache::params::package])

  if $::apache::params::devel == true {
    @package {$::apache::params::package_devel:
      ensure  => installed,
      alias   => 'apache-devel',
      notify  => Service['apache'],
      require => Package['apache'],
    }
    realize(Package[$::apache::params::package_devel])
  }

  if $::apache::params::ssl == true {
    @package {$::apache::params::package_ssl:
      ensure => installed,
      alias  => 'apache-ssl',
      notify => Service['apache'];
    }
    realize(Package[$::apache::params::package_ssl])
  }
}
