# == Class: apache::setup
#
# This class configures apache. So its more of a setup than config really.
#
class apache::setup {
  require apache::params

  ## Apache main configuration file
  #file { 'apache-config_file':
  #  ensure  => present,
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  path    => $::apache::params::config_file,
  #  content => template($::apache::params::config_template),
  #  notify  => Service['apache'],
  #}

  Augeas {
    lens    => 'Httpd.lns',
    incl    => $::apache::params::config_file,
    context => "/files${::apache::params::config_file}",
  }


  case $::apache::params::keepalive {
    true,'true',/(?i:on)/:    { $_keepalive = 'On' }
    false,'false',/(?i:off)/: { $_keepalive = 'Off' }
    default:                  { $_keepalive = 'On' }
  }

  apache::augeas::set {'ServerRoot': value => $::apache::params::config_dir, }
  apache::augeas::set {'KeepAlive':  value => $_keepalive, }
  apache::augeas::set {'User':       value => $::apache::params::daemon_user, }
  apache::augeas::set {'Group':      value => $::apache::params::daemon_group, }

  augeas {'apache-setup-default-include':
    notify  => Service['apache'],
    changes => [
      'ins directive after *[last()]',
      'set directive[last()] "Include"',
      'set directive[last()]/arg "conf.d/*.conf"',
    ],
    onlyif  => 'match directive[.="Include" and arg="conf.d/*.conf"] size == 0',
  }

  ## conf.d directory
  $apache_confd = 'apache_confd'
  file { $apache_confd:
    ensure  => directory,
    path    => $::apache::params::confd,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  ## log folders
  file {'apache-log_root':
    ensure => directory,
    path   => $::apache::params::log_dir,
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
