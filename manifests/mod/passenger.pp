# == Class: apache::mod::passenger
#
# For CentOS/Redhat, we use rubygems to install mod_passenger!
#
# === Parameters:
#
# $package::      Override the name of the package to install.
#                 Or set to false to manage the package outside the apache
#                 or passenger module.
#
# $provider::     Override the (package) provider to use while installing.
#                 Defaults to 'apt' for debian based distros and to
#                 'gem' for redhat based distros. If a package name has
#                 been given explicitly, the default provider will not be
#                 changed from whatever is default the package type.
#
# === Todo:
#
# TODO: Update documentation
# TODO: Add or use LoadModule support
# TODO: Implement basic configuration for those that do not have the passenger
#       module.
#
class apache::mod::passenger (
  $package        = undef,
  $provider       = undef,
  $notify_service = undef,
  $ensure         = 'present',
) {

  if $package != false {
    if defined('::passenger::module') and (($ensure == 'present') or ($ensure == true)) {
      require passenger::module

      if ! defined(Class['::passenger']) {
        class {'::passenger':
          before => Service['apache'],
        }
      }
    } else {

      case $package {
        undef: {
          case $::osfamily {
            'Debian': {
              $pkg_name = 'libapache2-mod-passenger'
              $pkg_provider = 'apt'
            }
            'RedHat': {
              $pkg_name = 'passenger'
              $pkg_provider = 'gem'
            }
            default: {
              fail('Your operatingsystem is not supported by apache::mod:passenger and no package provided')
            }
          }
        }
        default: {
          $pkg_name = $package
          $pkg_provider = $provider
        }
      }

      apache::sys::modpackage {'passenger':
        ensure         => $ensure,
        package        => $pkg_name,
        notify_service => $notify_service,
        provider       => $pkg_provider,
      }

      case $::osfamily {
        'RedHat': {
          if $pkg_provider == 'gem' {
            Apache::Sys::Modpackage['passenger'] {
              require   +> Package['rubygems'],
            }
          }
        }
        default: {}
      }
    }
  }
  else {
    notify {'Passenger is unmanaged': }
    # package is unmanaged
  }
}
