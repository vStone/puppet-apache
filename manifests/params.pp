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
# $notify_service::     Notify the service by default after a config change.
#                       Defaults to true.
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
  $harden            = false,
  $logrotate_d       = '/etc/logrotate.d/',
  $reload_command    = undef
) {

  case $::osfamily {
    'Debian': {
      $osdefault_package                = 'apache2'
      $osdefault_package_devel          = 'apache2-threaded-dev'
      $osdefault_package_ssl            = []
      $osdefault_service_name           = 'apache2'
      $osdefault_service_path           = '/etc/init.d/'
      $osdefault_service_hasrestart     = true
      $osdefault_service_hasstatus      = true
      $osdefault_service_reload_command =
        '/etc/init.d/apache2 reload > /dev/null'
      $osdefault_config_dir             = '/etc/apache2'
      $osdefault_config_file_rel        = 'apache2.conf'
      $osdefault_log_dir                = '/var/log/apache2'
      $osdefault_module_root            = 'modules'
      $osdefault_daemon_user            = 'www-data'
      $osdefault_daemon_group           = 'www-data'
      # class beneath apache::setup::os with distro specific tweaks
      $custom_os_setup                  = 'debian'
    }
    'RedHat': {
      $osdefault_package                = 'httpd'
      $osdefault_package_devel          = 'httpd-devel'
      $osdefault_package_ssl            = 'mod_ssl'
      $osdefault_service_name           = 'httpd'
      $osdefault_service_path           = '/etc/init.d/'
      $osdefault_service_hasrestart     = true
      $osdefault_service_hasstatus      = true
      $osdefault_service_reload_command =
        '/sbin/service httpd reload > /dev/null 2>/dev/null || true'
      $osdefault_config_dir             = '/etc/httpd'
      $osdefault_config_file_rel        = 'conf/httpd.conf'
      $osdefault_log_dir                = '/var/log/httpd'
      $osdefault_module_root            = 'modules'
      $osdefault_daemon_user            = 'apache'
      $osdefault_daemon_group           = 'apache'
      # class beneath apache::setup::os with distro specific tweaks
      $custom_os_setup                  = 'redhat'
    }
    'Archlinux': {
      $osdefault_package                = 'apache'
      $osdefault_package_devel          = []
      $osdefault_package_ssl            = []
      $osdefault_service_name           = 'httpd'
      $osdefault_service_path           = '/etc/rd.d/'
      $osdefault_service_hasrestart     = true
      $osdefault_service_hasstatus      = true
      $osdefault_service_reload_command =
        '/bin/kill -HUP `cat /var/run/httpd/httpd.pid 2>/dev/null` 2> /dev/null || true'
      $osdefault_config_dir             = '/etc/httpd'
      $osdefault_config_file_rel        = 'conf/httpd.conf'
      $osdefault_log_dir                = '/var/log/httpd'
      $osdefault_module_root            = 'modules'
      $osdefault_daemon_user            = 'http'
      $osdefault_daemon_group           = 'http'
    }
    default: {
      fail("osfamily ${::osfamily} not supported by the apache-module. add support in the params class and send a pull request ;)")
      $osdefault_package                = 'httpd'
      $osdefault_package_devel          = []
      $osdefault_package_ssl            = []
      $osdefault_service_name           = 'httpd'
      $osdefault_service_path           = '/etc/init.d/'
      $osdefault_service_hasrestart     = true
      $osdefault_service_hasstatus      = true
      $osdefault_service_reload_command =
        "/usr/bin/killall -HUP ${service_name}"
      $osdefault_config_dir             = '/etc/httpd'
      $osdefault_config_file_rel        = 'conf/httpd.conf'
      $osdefault_log_dir                = '/var/log/httpd'
      $osdefault_module_root            = 'modules'
      $osdefault_daemon_user            = 'apache'
      $osdefault_daemon_group           = 'apache'
    }
  }


  ####################################
  ####         Package(s)         ####
  ####################################
  $package = $apache ? {
    undef   => $osdefault_package,
    default => $apache,
  }
  $package_devel = $apache_dev ? {
    undef   => $osdefault_package_devel,
    default => $apache_dev,
  }
  $package_ssl = $apache_ssl ? {
    undef   => $osdefault_package_ssl,
    default => $apache_ssl,
  }


  ####################################
  ####      Apache Service        ####
  ####################################
  $service_name = $service ? {
    undef   => $osdefault_service_name,
    default => $service,
  }

  $service_reload_command = $reload_command ? {
    undef   => $osdefault_service_reload_command,
    default => $reload_command,
  }

  # these only have fixed os defaults (for now)
  $service_path       = $osdefault_service_path
  $service_hasrestart = $osdefault_service_hasrestart
  $service_hasstatus  = $osdefault_service_hasstatus


  ####################################
  #### Apache Configuration Files ####
  ####################################
  ## Configuration directories. Based on defined $configroot ##
  $config_dir = $configroot ? {
    undef   => $osdefault_config_dir,
    default => $configroot,
  }

  ## Location of the (main) configuration file.
  $config_file = "${config_dir}/${osdefault_config_file_rel}"

  ## conf.d folder.
  $confd       = "${config_dir}/conf.d"

  ## Log directory.
  $log_dir = $logroot ? {
    undef   => $osdefault_log_dir,
    default => $logroot,
  }

  case $config_style {
    undef: {
      if defined('::concat::setup') {
        $config_base = 'apache::sys::config::concat'
      } else {
        $config_base = 'apache::sys::config::split'
      }
    }
    /::/: {
      $config_base = $config_style
    }
    default: {
      $config_base = "apache::sys::config::${config_style}"
    }
  }

  ## Path used in the httpd config file to load modules.
  # This path is not used on all operating systems. Debian-ish systems
  # have their files in mods-available and symlink in mods-enabled.
  # See apache::config::loadmodule for more information.
  $module_root = $moduleroot ? {
    undef   => $osdefault_module_root,
    default => $moduleroot,
  }

  ####################################
  ####    Apache Daemon Config    ####
  ####################################
  $daemon_user = $user ? {
    undef   => $osdefault_daemon_user,
    default => $user,
  }
  $daemon_group = $group ? {
    undef   => $osdefault_daemon_group,
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
