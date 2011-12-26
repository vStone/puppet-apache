# == Class: apache::config
#
# This class configures apache. So its more of a setup than config really.
#
#
class apache::config {
  require apache::params

  ## Apache main configuration file
  file { 'apache-config_file':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    path    => $apache::params::config_file,
    content => template($apache::params::config_template),
    notify  => Service['apache'],
  }

  ## conf.d directory
  $apache_confd = 'apache_confd'
  file { $apache_confd:
    ensure  => directory,
    path    => $apache::params::confd,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }


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

  ## log folders
  file {'apache-log_root':
    ensure => directory,
    path   => $apache::params::log_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }


  include apache::config::listen
  include apache::config::namevhost
  include apache::config::mod
  include apache::config::vhost

}
