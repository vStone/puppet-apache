class apache::mod::passenger {

  $pkg_name = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'libapache2-mod-passenger',
    /Centos|RedHat/ => 'passenger',
    default         => [],
  }

  package { $pkg_name:
    ensure  => installed,
    alias   => 'apache_mod_passenger',
    require => Package['apache'],
  }

  case $::operatingsystem {
    /Debian|Ubuntu/: {
      Package[$pkg_name] {
        provider  => 'apt',
      }
    }
    /CentOS|RedHat/: {
      Package[$pkg_name] {
        provider  => 'gem',
        require   +> Package['rubygems'],
      }
    }
    default: {}
  }

}
