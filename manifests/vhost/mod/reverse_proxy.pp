# == Definition: apache::vhost::mod::proxy
#
# Setup mod_proxy in a vhost.
#
# === Parameters:
#
#   $vhost:
#     The name of the vhost to work on.
#     This should be identical to the apache::vhost{NAME:} you have setup.
#
#   $ip:
#     Ip of the vhost to work on. Should be identical to the apache::vhost
#     instance you have setup. Defaults to '*'
#
#   $port:
#     Port of the vhost to work on. Should be identical to the apache::vhost
#     instance you have setup. Defaults to '80'
#
#   $ensure:
#     If ensure is absent, the configuration file will be removed.
#
#   $content:
#     Extra content to add to the configuration file.
#
#   $proxy_url:
#     The proxy url is used in <Proxy></Proxy> directives to limit access.
#     Defaults to '*' (all)
#
#   $allow_order:
#     Should be either deny,allow or allow,deny. Configures permissions.
#
#   $allow_from:
#   $deny_from:
#
#   $proxypass:
#
#   $proxypassreverse:
#
#   $proxypath:
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
