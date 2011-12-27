# == Class: apache::vhost
#
# === Parameters:
#
define apache::vhost (
  $servername     = undef,
  $serveraliases        = [],
  $ensure         = 'present',
  $ip             = undef,
  $port           = '80',
  $admin          = undef,
  $docroot        = undef,
  $docroot_purge  = false,
  $order          = '01',
  $mods           = undef
) {

  require apache::params
  require apache::config::vhost

  ## Just keep names the same for as much as possible.

  $server = $servername ? {
    undef   => $name,
    default => $servername,
  }

  $serveradmin = $admin ? {
    undef   => "admin@${server}",
    default => $admin,
  }

  $vhost_root = "${apache::params::vhost_root}/${server}"
  $log_dir    = "${apache::params::vhost_log_dir}/${server}"
  $log_link_target = "${vhost_root}/logs"

  $documentroot = $docroot ? {
    undef   => "${vhost_root}/${apache::params::default_docroot}",
    default => $docroot,
  }

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

  # setup paths / folders / symlinks
  # keep order in mind

  apache::vhost::maybe {"apache-vhost-vhost-root-${name}":
    ensure => 'directory',
    path   => $vhost_root,
  }
  apache::vhost::maybe {"apache-vhost-vhost-log-${name}":
    ensure  => 'directory',
    path    => $log_dir,
    require => File['apache-vhosts_log_root'],
  }
  apache::vhost::maybe {"apache-vhost-vhost-log-link-${name}":
    ensure  => 'link',
    target  => $log_dir,
    path    => $log_link_target,
    require => [ Apache::Vhost::Maybe["apache-vhost-vhost-log-${name}"],
                 Apache::Vhost::Maybe["apache-vhost-vhost-root-${name}"] ]
  }


  # ensure present (We'll be using symlink magic for this part!)

  # manage create root.

  # template magic.
  $includeglob = "${server}_mod_*.conf"

  # if mods is defined, do some create_resources magic.


}
