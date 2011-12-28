# == Class: apache::vhost
#
#   Define a apache vhost.
#
# === Parameters:
#
#   $name:
#     The name is used for the filenames of various configuration files.
#     It is a good idea to use <servername>_<port> so there is no overlapping
#     of configuration files.
#
#   $servername:
#     The server name to use.
#
#   $ensure:
#     Can either be present/enabled/true or absent/disabled/false.
#
#   $ip:
#     The ip to use. Must match with a apache::namevhost.
#
#   $port:
#     The port to use. Must match with apache::namevhost.
#     Defaults to '80'/
#
#   $admin:
#     Admin email address.
#     Defaults to admin@SERVERNAME
#
#   $vhostroot
#     Root where all other files for this vhost will be created under.
#     Defaults to the globally defined vhost root folder.
#
#   $docroot:
#     Document root for this vhost.
#     Defaults to /<vhostroot>/<servername>/<htdocs>
#
#   $docroot_purge:
#     If you are going to manage the content of the document root with
#     puppet alone, you can safely enable purging here. This will also
#     remove any file/dir that is not managed by puppet.
#
#   $order:
#     Can be used to define the order for this vhost to be loaded in.
#     Defaults to 10. So special vhosts should have a lower or higher order.
#
#   $vhost_config:
#     Custom virtualhost configuration.
#     This does not override the complete config but is included within
#     the <VirtualHost> directive after the documentroot definition,
#     and before including any apache vhost mods.
#
#   $mods: Currently not implemented!
#
# === Best practice:
#
#   Try and to use something unique for the name of each vhost defintion.
#   You can use the same  port, ip and servername for different definitions,
#   but the combination of all 3 always has to be unique!
#
# === Todo:
#  * Write the mods system
#
define apache::vhost (
  $servername     = undef,
  $serveraliases  = [],
  $ensure         = 'present',
  $ip             = undef,
  $port           = '80',
  $admin          = undef,
  $vhostroot      = undef,
  $logdir         = undef,
  $docroot        = undef,
  $docroot_purge  = false,
  $order          = '10',
  $vhost_config   = '',
  $mods           = undef
) {

  require apache::params
  require apache::config::vhost

  ####################################
  ####  Param checks & Defaults   ####
  ####################################

  case $ensure {
    /enable|present/, true:   { $enable = true }
    /disable|absent/, false:  { $enable = false }
    default: {
      warning('Only enable/present/true/disable/absent/false are valid values for the ensure parameter')
      $enable = true
    }
  }

  $server = $servername ? {
    undef   => $name,
    default => $servername,
  }

  $serveradmin = $admin ? {
    undef   => "admin@${server}",
    default => $admin,
  }

  $vhost_root = $vhostroot ? {
    undef   => "${apache::params::vhost_root}/${server}",
    default =>  $vhostroot,
  }

  $log_dir = $logdir ? {
    undef   => "${apache::params::vhost_log_dir}/${server}",
    default => $logdir,
  }

  $log_link_target = "${vhost_root}/logs"

  $documentroot = $docroot ? {
    undef   => "${vhost_root}/${apache::params::default_docroot}",
    default => $docroot,
  }

  ## Check for matching apache::namevhost
  case $ip {
    undef: {
      $ip_def = '*'
      $listen = $port
    }
    default: {
      $ip_def = $ip
      $listen = "${ip}_${port}"
    }
  }

  if ($ensure == 'present') and ( ! defined (Apache::Namevhost[$listen])) {
    warning("You need to define the Apache::Namevhost['${listen}'] before the vhost '${name}' will be enabled.")
  }


  ####################################
  ####   Create folder structure  ####
  ####################################
  apache::vhost::file_exists {"apache-vhost-vhost-root-${name}":
    ensure => 'directory',
    path   => $vhost_root,
  }
  apache::vhost::file_exists {"apache-vhost-vhost-log-${name}":
    ensure  => 'directory',
    path    => $log_dir,
    require => File['apache-vhosts_log_root'],
  }
  apache::vhost::file_exists {"apache-vhost-vhost-log-link-${name}":
    ensure  => 'link',
    target  => $log_dir,
    path    => $log_link_target,
    require => [
      Apache::Vhost::File_exists["apache-vhost-vhost-log-${name}"],
      Apache::Vhost::File_exists["apache-vhost-vhost-root-${name}"]
    ]
  }

  # manage create root.

  # template magic.
  $includeglob = "${server}_mod_*.conf"

  $inclfile_title = "${name}_"

  case $apache::params::config_style {
    'use_ip': {
      apache::vhost::config::use_ip { $title:
        ensure  => $enable,
        name    => $name,
        order   => $order,
        content => template('apache/vhost/virtualhost.erb'),
      }
    }
    'simple','default',default: {
      apache::vhost::config::simple { $title:
        ensure  => $enable,
        name    => $name,
        order   => $order,
        content => template('apache/vhost/virtualhost.erb'),
      }
    }
  }
  # if mods is defined, do some create_resources magic.


}