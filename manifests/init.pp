import 'packages.pp'
import 'config.pp'
import 'service.pp'
import 'mod/passenger.pp'
import 'mod/prefork.pp'
import 'mod/php.pp'
import 'mod/xsendfile.pp'
import 'nginx/*'

class apache (
  $apache = $::operatingsystem ? {
    debian    => 'apache2',
    default   => 'httpd',
  },
  $root = $::operatingsystem ? {
    debian    => '/etc/apache2',
    default   => '/etc/httpd',
  },
  $user = $::operatingsystem ? {
    archlinux => 'http',
    debian    => 'www-data',
    default   => 'apache',
  },
  $group = $::operatingsystem ? {
    archlinux => 'http',
    debian    => 'www-data',
    default   => 'apache',
  },
  $devel = 'no',
  $ssl = 'yes'
) {

  include apache::packages
  include apache::config
  include apache::service

  Class['apache::packages'] -> Class['apache::config'] -> Class['apache::service']
}

class nginx {
  include nginx::packages
  include nginx::service
  include nginx::config

  Class['nginx::packages'] -> Class['nginx::config'] -> Class['nginx::service']
}
