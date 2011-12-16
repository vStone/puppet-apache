# Class: apache::params
#
# Configure various apache settings and initialize distro specific settings.
#
# Parameters:
#   $apache:
#     Configure the apache package name. Defaults do distro specific.
#
#   $apache_dev:
#     Package(s) to install when $devel = 'yes'. Defaults to distro specific.
#
#   $apache_ssl:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#
class apache::params(
  $apache = undef,
  $apache_dev = undef,
  $apache_ssl = undef,
  $service = undef,
  $root = undef,
  $user = undef,
  $group = undef,
  $devel = 'no',
  $ssl = 'yes'
) {


  $package = $apache ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'apache2',
      /CentOS|RedHat/ => 'httpd',
      default         => 'httpd',
    },
    default => $apache,
  }
  $package_devel = $apache_dev ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'apache2-threaded-dev',
      /CentOS|RedHat/ => 'httpd-devel',
      /Archlinux/     => [],
      default         => [],
    },
    default => $apache_dev,
  }
  $package_ssl = $apache_ssl ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => [],
      /CentOS|RedHat/ => 'mod_ssl',
      default         => [],
    },
    default => $apache_ssl,
  }

  $service_name = $service ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'apache2',
      /CentOS|RedHat/ => 'httpd',
      /Archlinux/     => 'httpd',
      default         => 'httpd',
    },
    default => $service,
  }
  $service_path = $::operatingsystem ? {
    /Archlinux/     => '/etc/rc.d/',
    default         => '/etc/init.d/',
  }

  $service_hasrestart = $::operatingsystem ? {
    default         => true,
  }

  $service_hasstatus = $::operatingsystem ? {
    default         => true,
  }

  $config_dir = $root ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => '/etc/apache2',
      /CentOS|RedHat/ => '/etc/httpd',
      default         => '/etc/httpd',
    },
    default => $root,
  }

  $config_path = $::operatingsystem ? {
    /Debian|Ubuntu/ => "${config_dir}/apache2.conf",
    /CentOS|RedHat/ => "${config_dir}/conf/httpd.conf",
    default         => "${config_dir}/conf/httpd.conf",
  }

  $config_template = $::operatingsystem ? {
    /Archlinux/     => 'apache/archlinux-apache.conf.erb',
    /CentOS|RedHat/ => $::operatingsystemrelease ? {
      /^6/    => 'apache/centos6-apache.conf.erb',
      /^5/    => 'apache/centos-apache.conf.erb',
      default => 'apache/centos-apache.conf.erb',
    },
    /Debian|Ubuntu/ => 'apache/debian-apache.conf.erb',
    default         => 'apache/debian-apache.conf.erb',
  }

  $daemon_user = $user ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'www-data',
      /CentOS|RedHat/ => 'apache',
      /Archlinux/     => 'http',
      default         => 'apache',
    },
    default => $user,
  }
  $daemon_group = $group ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'www-data',
      /CentOS|RedHat/ => 'apache',
      /Archlinux/     => 'http',
      default         => 'apache',
    },
    default => $group,
  }

}
