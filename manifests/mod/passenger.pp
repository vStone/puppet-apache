# == Class: apache::mod::passenger
#
# For CentOS/Redhat, we use rubygems to install mod_passenger!
#
# === Todo:
#
# TODO: Update documentation
# TODO: Add or use LoadModule support
# TODO: Implement basic configuration for those that do not have the passenger
#       module.
# TODO: Support installing using gems or use system packages
#
class apache::mod::passenger (
  $package       = undef
) {

  if defined('::passenger::module') {
    require passenger::module
    if ! defined(Class['passenger']) {
      include passenger
    }
  } else {

    case $package {
      undef: {
        case $::operatingsystem {
          /(?i:debian|ubuntu)/: { $pkg_name = 'libapache2-mod-passenger' }
          /(?i:centos|redhat)/: { $pkg_name = 'passenger' }
          default: {
            fail('Your operatingsystem is not supported by apache::mod:passenger')
          }
        }
      }
      default: {
        $pkg_name = $package
      }
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
