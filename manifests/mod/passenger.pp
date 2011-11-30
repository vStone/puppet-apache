class apache::mod::passenger {
  package { 'passenger':
    ensure  => installed,
    name    => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'libapache2-mod-passenger',
      Centos          => 'passenger',
    },
    provider => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'apt',
      Centos          => 'gem',
    },
    require => Package['apache'],
  }
}
