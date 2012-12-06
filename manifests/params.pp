# == Class: apache::params
#
# Configure various apache settings and initialize distro specific settings.
#
# === Parameters:
#
# $apache::             Configure the apache package name.
#                       Defaults do distro specific.
#
# $apache_dev::         Package(s) to install when $devel = true.
#                       Defaults to distro specific.
#
# $apache_ssl::         Packages to install when $ssl = true.
#                       Defaults to distro specific.
#
# $service::            Name of the apache service.
#                       Defaults to distro specific.
#
# $configroot::         Root of all configuration files.
#                       Defaults to distro specific. This should NOT include
#                       a trailing '/' (forward-slash)
#
# $vhostroot::          Root where all vhost configuration is done. The
#                       structure beneath this folder is determined by the
#                       used $config_style.
#                       Defaults to distro specific.
#
# $vhostroot_purge::    Purge the vhost configuration root of all configuration
#                       files that are not managed by puppet.
#                       Defaults to false.
#
# $logroot::            Root where all log files are stored.
#                       Defaults to distro specific.
#
# $user::               User to run the apache daemon as.
#                       Defaults to distro specific.
#
# $group::              Group to run apache daemon as.
#                       Defaults to distro specific.
#
# $devel::              Include development packages. Sometimes required for
#                       building custom apache modules.
#
# $ssl::                Use ssl or not. On some distro's, we need to install
#                       some additional packages for this to work properly.
#                       Defaults to true.
#
# $keepalive::          Enable keepalive in the main configuration file.
#                       Defaults to true.
#
# $config_style::       Allows to pick the configuration style you want to
#                       generate. If this is a simple string, the used class
#                       will be:
#                         apache::sys::config::${config_style}:: *
#                       When the string contains '::', we will use that
#                       exact definition.
#                       Defaults to 'concat'.
#
# $default_docroot::    The default document root to use beneath each
#                       vhost documentroot folder. Defaults to 'htdocs'.
#
# $diroptions::         Default directory Options to use for a vhost.
#                       Defaults to 'FollowSymlinks MultiViews'
#
# $default_logformat::  Set the default logformat to use for vhosts.
#                       Defaults to 'combined'.
#
# $default_accesslog::  Default accesslog format. Defaults to 'access.log'.
#                       You can use some placeholders in the format. See
#                       _Log Placeholders_ for more information.
#
# $default_errorlog::   Default errorlog format. Defaults to 'error.log'.
#                       You can use some placeholders in the format. See
#                       _Log Placeholders_ for more information.
#
# $placeholder_ssl::    The string to use as the is_ssl placeholder if the
#                       vhost is ssl enabled. If the vhost does not use ssl,
#                       it will be empty. Defaults to '_ssl' (including! the
#                       underscore).
#
# === Log Placeholders:
#
# The following placeholders can be used when providing the format for the
# access and/or errorlog.
#
# name::                Is replaced with the apache::vhost name provided.
# servername::          Is replaced with the ServerName that is configured.
# port::                Is replaced with the port.
# listen::              Is replaced with the Listen directive this vhost is
#                       using. This is a combination of +ip+:+port+ or just
#                       +port+.
# ip::                  This is the IP this vhost is for or '+all+' if the
#                       vhost is for all (ip is '*')
# ssl::                 Is replaced with the +$placeholder_ssl+ for a ssl vhost.
# harden::              Include apache::security class by default.
#                       Defaults to false.
#
#
# ==== Example:
#
#   class {'apache::params':
#     $default_accesslog => '%servername_%port%ssl_access.log',
#     $placeholder_ssl   => '_ssl',
#   }
#
#   apache::vhost::ssl {'localhost_443':
#     /* SSL PARAMETERS */
#   }
#   # the access log will be called: 'localhost_443_ssl_access.log'
#
#   apache::vhost {'localhost_80': }
#   # the access log will be called: 'localhost_80_access.log'
#
#
# === Todo:
#
# TODO: Finish documentation.
# TODO: Test /out of scope/ config_style stuff.
#
class apache::params(
  $apache            = undef,
  $apache_dev        = undef,
  $apache_ssl        = undef,
  $service           = undef,
  $configroot        = undef,
  $moduleroot        = undef,
  $vhostroot         = undef,
  $vhostroot_purge   = false,
  $logroot           = undef,
  $user              = undef,
  $group             = undef,
  $devel             = false,
  $ssl               = true,
  $keepalive         = true,
  $timeout           = 60,
  $config_style      = undef,
  $default_docroot   = 'htdocs',
  $diroptions        = ['FollowSymlinks','MultiViews'],
  $default_logformat = 'combined',
  $default_accesslog = 'access.log',
  $default_errorlog  = 'error.log',
  $default_admin     = undef,
  $placeholder_ssl   = '_ssl',
  $notify_service    = true,
  $defaults          = true,
  $harden            = false
) {

  ####################################
  ####         Package(s)         ####
  ####################################
  $package = $apache ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => 'apache2',
      /CentOS|RedHat/ => 'httpd',
      /Archlinux/     => 'apache',
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


  ####################################
  ####      Apache Service        ####
  ####################################
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


  ####################################
  #### Apache Configuration Files ####
  ####################################
  ## Configuration directories. Based on defined $configroot ##
  $config_dir = $configroot ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => '/etc/apache2',
      /CentOS|RedHat/ => '/etc/httpd',
      default         => '/etc/httpd',
    },
    default => $configroot,
  }

  ## Main configuration template to use.
  ## TODO: DEPRECATED. Remove!
  $config_template = $::operatingsystem ? {
    /Archlinux/     => 'apache/config/archlinux-apache.conf.erb',
    /CentOS|RedHat/ => $::operatingsystemrelease ? {
      /^6/    => 'apache/config/centos6-apache.conf.erb',
      /^5/    => 'apache/config/centos5-apache.conf.erb',
      default => 'apache/config/centos6-apache.conf.erb',
    },
    /Debian|Ubuntu/ => 'apache/config/debian-apache.conf.erb',
    default         => 'apache/config/debian-apache.conf.erb',
  }

  ## Location of the (main) configuration file.
  $config_file = $::operatingsystem ? {
    /Debian|Ubuntu/ => "${config_dir}/apache2.conf",
    /CentOS|RedHat/ => "${config_dir}/conf/httpd.conf",
    default         => "${config_dir}/conf/httpd.conf",
  }

  ## conf.d folder.
  $confd        = "${config_dir}/conf.d"

  ## Log directory.
  $log_dir = $logroot ? {
    undef   => $::operatingsystem ? {
      /Debian|Ubuntu/ => '/var/log/apache2',
      /CentOS|RedHat/ => '/var/log/httpd',
      /Archlinux/     => '/var/log/httpd',
      default         => '/var/log/httpd',
    },
    default => $logroot,
  }

  if defined('::concat') {
    $config_style_undef = 'apache::sys::config::concat'
  }
  else {
    $config_style_undef = 'apache::sys::config::split'
  }

  ## config_base
  $config_base = $config_style ? {
    undef   => $config_style_undef,
    /::/    => $config_style,
    default => "apache::sys::config::${config_style}"
  }

  $module_root = $moduleroot ? {
    undef   => $::operatingsystem ? {
      default => 'modules'
    },
    default => $moduleroot,
  }

  ####################################
  ####    Apache Daemon Config    ####
  ####################################
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

  ####################################
  ####     Vhost root folder      ####
  ####################################
  $vhost_root = $vhostroot ? {
    undef   => '/var/vhosts',
    default => $vhostroot,
  }
  $vhost_log_dir = "${log_dir}/vhosts"

}
