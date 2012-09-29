# == Class: apache::mod::prefork
#
# === Todo:
#
# TODO: Update documentation
# TODO: Add or use LoadModule support
#
class apache::mod::prefork (
  $notify_service = undef
) {

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_name = 'apache2-prefork-dev'
    }
    /(?i:centos|redhat)/: {
      $pkg_name = undef
    }
    default: {
      fail('Your operatingsystem is not supported by apache::mod::prefork')
    }
  }

  apache::sys::modpackage {'prefork':
    package         => $pkg_name,
    notify_service  => $notify_service,
  }

}
