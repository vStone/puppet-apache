# Class: apache::mod::xsendfile
#
# Requirements:
#  CentOS: epel repository.
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
