# == Class: apache::mod::xsendfile
#
# === Requirements:
#
# Packages!
#
# === Todo:
#
# TODO: Update documentation
# TODO: Add or use LoadModule support
# TODO: Allow configuration/overriding of packages to use.
#
class apache::mod::xsendfile {

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: { $pkg_name = 'libapache2-mod-xsendfile' }
    /(?i:centos|redhat)/: { $pkg_name = 'mod_xsendfile' }
    default: {
      fail('Your operatingsystem is not supported by apache::mod::xsendfile')
    }
  }

  package { $pkg_name:
    ensure  => installed,
    alias   => 'apache_mod_xsendfile',
  }

}
