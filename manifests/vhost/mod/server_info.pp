# == Definition: apache::vhost::mod::server_info
#
# Enable server info for this vhost.
#
# === Required Parameters:
#
# Some basic parameters that are always present in a module are not
# documented. See the apache::vhost::mod::dummy for an explanation on them.
#
# [*location*]
#   Location to serve the server info on.
#   Defaults to /server-info
#
# [*allow_order*]
#   Should be either deny,allow or allow,deny.
#   See: http://httpd.apache.org/docs/2.2/howto/access.html
#
# [*allow_from*]
#   Hosts, ips, ... where access should be allowed from.
#   Defaults to 'All'
#   See: http://httpd.apache.org/docs/2.2/howto/access.html
#
# [*deny_from*]
#   Hosts,ips, ... where access should be disallowed from.
#   Defaults to '' (empty).
#   See: http://httpd.apache.org/docs/2.2/howto/access.html.
#
# === Sample Usage:
#
# === Todo:
#
# TODO: Update documentation
#
define apache::vhost::mod::server_info (
  $vhost,
  $notify_service = undef,
  $ensure         = 'present',
  $ip             = undef,
  $port           = '80',
  $docroot        = undef,
  $order          = undef,
  $_automated     = false,
  $_header        = true,

  $comment        = undef,
  $location       = '/server-info',
  $allow_order    = 'Deny,Allow',
  $allow_from     = 'All',
  $deny_from      = undef
) {

  require apache::mod::info

  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/server_info.erb')

  apache::sys::modfile {$title:
    ensure         => $ensure,
    vhost          => $vhost,
    ip             => $ip,
    port           => $port,
    nodepend       => $_automated,
    content        => $definition,
    order          => $order,
    notify_service => $notify_service,
  }
}

