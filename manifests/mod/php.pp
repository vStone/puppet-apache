# == Class: apache::mod::php
#
# === Todo:
#
# TODO: Update documentation
# TODO: Add or use LoadModule support
#
class apache::mod::php (
  $notify_service = undef,
  $ensure = 'present',
) {

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_name = 'libapache2-mod-php'
    }
    /(?i:centos|redhat)/: {
      $pkg_name = 'php'
    }
    default: {
      fail('Your operatingsystem is not supported by apache::mod:php')
    }
  }

  apache::sys::modpackage {'php':
    ensure         => $ensure,
    package        => $pkg_name,
    notify_service => $notify_service,
  }

}
