# == Class: apache::setup
#
# This class configures apache. So its more of a setup than config really.
#
class apache::setup {
  require apache::params

  Augeas {
    lens    => 'Httpd.lns',
    incl    => $::apache::params::config_file,
    context => "/files${::apache::params::config_file}",
    require => Package['apache'],
    before  => Service['apache'],
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
  apache::augeas::set {'Timeout':    value => $::apache::params::timeout, }

  augeas {'apache-setup-default-include':
    notify  => Service['apache'],
    changes => [
      'ins directive after *[last()]',
      'set directive[last()] "Include"',
      'set directive[last()]/arg "conf.d/*.conf"',
    ],
    onlyif  => 'match directive[.=~regexp("Include(Optional)?") and arg="conf.d/*.conf"] size == 0',
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

  if $::apache::params::custom_os_setup {
    include "apache::setup::os::${::apache::params::custom_os_setup}"
  }

}
