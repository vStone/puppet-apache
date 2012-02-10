# == Class: apache::setup
#
# This class configures apache. So its more of a setup than config really.
#
#
class apache::setup {
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

  ## log folders
  file {'apache-log_root':
    ensure => directory,
    path   => $apache::params::log_dir,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }


  include apache::setup::listen
  include apache::setup::namevhost
  include apache::setup::mod
  include apache::setup::vhost

  case $::operatingsystem {
    /(?i:centos|redhat)/: { include apache::setup::os::centos }
    /(?i:debian|ubuntu)/: { include apache::setup::os::debian }
    default: {}
  }

}
