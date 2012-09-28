# == Class: apache::mod::prefork
#
# === Todo:
#
# TODO: Update documentation
# TODO: Add or use LoadModule support
#
class apache::mod::prefork {

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

  package { $pkg_name:
    ensure  => installed,
    alias   => 'apache_mod_prefork'
  }

}
