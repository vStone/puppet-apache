class apache::config::vhost {

  $confd = 'vhost.d'
  $order = '10'
  $includes = ['*.conf' ]
  $purge  = false

  $use_config_root = true

  ## vhost doc roots
  file{'apache-vhost_root':
    ensure => directory,
    path   => $apache::params::vhost_root,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file {'apache-vhosts_log_root':
    ensure  => directory,
    path    => $apache::params::vhost_log_dir,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['apache-log_root'],
  }

  apache::confd {'vhost':
    confd           => $apache::config::vhost::confd,
    order           => $apache::config::vhost::order,
    load_content    => '',
    warn_content    => '',
    includes        => $apache::config::vhost::includes,
    purge           => $apache::config::vhost::purge,
    use_config_root => $apache::config::vhost::use_config_root,
  }

}
