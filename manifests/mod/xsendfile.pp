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

  $pkg_name = $::operatingsystem ? {
    /Debian|Ubuntu/         => 'libapache2-mod-xsendfile',
    /CentOS|Fedora|RedHat/  => 'mod_xsendfile',
  }

  package { $pkg_name:
    ensure  => installed,
    alias   => 'apache_mod_xsendfile',
  }

}
