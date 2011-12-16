class apache::packages {
  require apache::params

  @package {$apache::params::package:
    ensure  => installed,
    alias   => 'apache',
    notify  => Service['apache'];
  }
  @package {$apache::params::package_devel:
    ensure  => installed,
    alias   => 'apache-devel',
    notify  => Service['apache'],
    require => Package['apache'],
  }
  @package {$apache::params::package_ssl:
      ensure => installed,
      alias  => 'apache-ssl',
      notify => Service['apache'];
  }

  realize(Package[$apache::params::package])

  if $apache::params::devel == 'yes' {
    realize(Package[$apache::params::package_devel])
  }
  if $apache::params::ssl == 'yes' {
    realize(Package[$apache::params::package_ssl])
  }
}
