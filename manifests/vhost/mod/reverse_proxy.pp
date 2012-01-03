# == Definition: apache::vhost::mod::proxy
#
# Setup mod_proxy in a vhost.
#
# === Parameters:
#
#
#
define apache::vhost::mod::reverse_proxy (
  $vhost,
  $ip           = undef,
  $port         = '80',
  $ensure       = 'present',
  $content      = '',
  $proxy_url    = '*',
  $allow_order  = 'Deny, Allow',
  $allow_from   = 'All',
  $deny_from    = '',
  $proxypass    = undef,
  $proxypassreverse = undef
) {

  $definition = template('apache/vhost/mod/reverse_proxy.erb')

  apache::vhost::modfile {$title:
    ensure  => $ensure,
    vhost   => $vhost,
    ip      => $ip,
    port    => $port,
    content => $definition,
  }

}
