# == Class: apache::mod::passenger
#
# For CentOS/Redhat, we use rubygems to install mod_passenger!
#
# === Parameters:
#
# [*package*]
#   Override the name of the package to install.
#   Or set to false to manage the package outside the apache
#   or passenger module.
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
            }
            'RedHat': {
              $pkg_name = 'mod_passenger'
            }
            default: {
              fail('Your operatingsystem is not supported by apache::mod:passenger and no package provided')
            }
          }
        }
        default: {
          $pkg_name = $package
        }
      }

      apache::sys::modpackage {'passenger':
        ensure         => $ensure,
        package        => $pkg_name,
        notify_service => $notify_service,
      }
    }
  }
  else {
    notify {'Passenger is unmanaged': }
    # package is unmanaged
  }
}
