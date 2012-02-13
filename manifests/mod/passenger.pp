class apache::mod::passenger {

  if defined('::passenger::module') {
    require passenger::module
    notify {'apache-mod-passenger-detect-passenger-module':
      message => "O Hi! I detected that you using a (pluggeable?) passenger module (${passenger::module::id}). Trying to work with it!"
    }
    require passenger
  } else {

    ## @Todo: Do we even need this here? I'm unsure it still works.


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
}
