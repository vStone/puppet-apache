# == Class: apache::service
#
# Sets up and enables the apache service.
#
class apache::service {
  require apache::params

  service { 'apache':
    ensure      => running,
    enable      => true,
    name        => $::apache::params::service_name,
    path        => $::apache::params::service_path,
    hasrestart  => $::apache::params::service_hasrestart,
    hasstatus   => $::apache::params::service_hasstatus,
    require     => Package['apache'],
  }
}
