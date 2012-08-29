# = Definition: apache::vhost::mod::proxy
#
# Setup mod_proxy in a vhost.
#
# == Parameters:
#
# $vhost::            The name of the vhost to work on. This should be
#                     identical to the apache::vhost{NAME:} you have setup.
#
# $ip::               Ip of the vhost to work on. Should be identical to the
#                     apache::vhost instance you have setup. Defaults to '*'
#
# $port::             Port of the vhost to work on. Should be identical to
#                     the apache::vhost instance you have setup.
#                     Defaults to '80'
#
# $ensure::           If ensure is absent, the configuration file will be
#                     removed. Defaults to 'present'.
#
# $content::          Extra content to add to the configuration file.
#
# $proxy_url::        The proxy url is used in <Proxy></Proxy> directives to
#                     limit access. Defaults to '*' (all).
#                     See: http://tinyurl.com/apache-mod-proxy#proxy
#
# $allow_order::      Should be either deny,allow or allow,deny.
#                     See: http://httpd.apache.org/docs/2.2/howto/access.html
#
# $allow_from::       Hosts, ips, ... where access should be allowed from.
#                     Defaults to 'All'
#                     See: http://httpd.apache.org/docs/2.2/howto/access.html
#
# $deny_from::        Hosts,ips, ... where access should be disallowed from.
#                     Defaults to '' (empty).
#                     See: http://httpd.apache.org/docs/2.2/howto/access.html.
#
# $proxypass::        This can either be a single string, an array or a hash.
#                     For each entry, a ProxyPass directive will be written to
#                     the configuration file.
#                     See: http://tinyurl.com/apache-mod-proxy#proxypass
#
# $proxypassreverse:: This can either be a single string, an array or a hash.
#                     For each entry, a ProxyPassReverse directive will be
#                     written to the configuration file.
#                     See: http://tinyurl.com/apache-mod-proxy#proxypassreverse
#
# $proxypath::        This can either be a single string, an array or a hash.
#                     For each entry, a ProxyPass AND ProxyPassReverse
#                     directive will be written to the configuration file.
#
# $default_proxy_pass_options:: A hash containing additional options to add to
#                     the proxypass directive. If specified, we will append these
#                     options to each proxypass line we define.
#                     If this is undefined, we will use the options
#                     provided in apache::mod::reverse_proxy. To disable using those
#                     just pass an empty hash. Defaults to undefined.
#
define apache::vhost::mod::reverse_proxy (
  $vhost,
  $ip           = undef,
  $port         = '80',
  $ensure       = 'present',
  $docroot      = undef,
  $content      = undef,
  $proxy_url    = '*',
  $allow_order  = 'Deny,Allow',
  $allow_from   = 'All',
  $deny_from    = undef,
  $proxypass    = undef,
  $proxypassreverse = undef,
  $proxypath    = undef,
  $default_proxy_pass_options = undef,
  $automated    = false
) {


  case $default_proxy_pass_options {
    undef: {
      require apache::mod::reverse_proxy
      $_proxypass_options = $::apache::mod::reverse_proxy::default_proxy_pass_options
    }
    default: {
      $_proxypass_options = $default_proxy_pass_options
    }
  }

  case $allow_order {
    /(?i:deny,allow)/: {}
    /(?i:allow,deny)/: {}
    default: {
      fail( template('apache/msg/mod-revproxy-allow-order-fail.erb') )
    }
  }

  $definition = template('apache/vhost/mod/reverse_proxy.erb')

  apache::vhost::modfile {$title:
    ensure    => $ensure,
    vhost     => $vhost,
    ip        => $ip,
    port      => $port,
    content   => $definition,
    nodepend  => $automated,
  }

}
