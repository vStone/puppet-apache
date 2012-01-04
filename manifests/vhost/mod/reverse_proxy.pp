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
  $allow_order  = 'Deny,Allow',
  $allow_from   = 'All',
  $deny_from    = '',
  $proxypass    = undef,
  $proxypassreverse = undef,
  $proxypath    = undef
) {

  case $allow_order {
    /(?i:deny,allow)/: {}
    /(?i:allow,deny)/: {}
    default: {
      fail("Only 'allow,deny' or 'deny,allow' are allowed values for allow_order. Defined value: ${allow_order}")
    }
  }

  $definition = template('apache/vhost/mod/reverse_proxy.erb')

  apache::vhost::modfile {$title:
    ensure  => $ensure,
    vhost   => $vhost,
    ip      => $ip,
    port    => $port,
    content => $definition,
  }

}
