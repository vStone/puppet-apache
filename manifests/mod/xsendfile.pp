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
class apache::mod::xsendfile (
  $notify_service = undef,
  $ensure = 'present',
) {

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: { $pkg_name = 'libapache2-mod-xsendfile' }
    /(?i:centos|redhat)/: { $pkg_name = 'mod_xsendfile' }
    default: {
      fail('Your operatingsystem is not supported by apache::mod::xsendfile')
    }
  }

  apache::sys::modpackage {'xsendfile':
    ensure         => $ensure,
    package        => $pkg_name,
    notify_service => $notify_service,
  }

  apache::config::loadmodule {'xsendfile':
    ensure         => $ensure,
    notify_service => $notify_service,
  }

}
