class apache::security::redhat {

  include apache::params

  file {"${::apache::params::confd}/welcome.conf":
    ensure => 'absent',
  }

}
