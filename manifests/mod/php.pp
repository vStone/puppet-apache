# == Class: apache::mod::php
#
# === Todo:
#
# TODO: Update documentation
# TODO: Add or use LoadModule support
#
class apache::mod::php {

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


  package { $pkg_name:
    ensure  => installed,
    alias   => 'apache_mod_php',
    require => Package['apache'],
    notify  => Service['apache'],
  }

}
