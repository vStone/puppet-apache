# == Definition: apache::vhost::mod::server_info
#
# Enable server info for this vhost.
#
# === Required Parameters:
#
# Your definition should always take the following parameters. When
# using the mods parameter from vhost, these get set automaticly.
#
# $ensure::       Disable or enable this mod. This will/should remove the config
#                 file. Required for apache::sys::modfile.
#
# $vhost::        Defined what vhost this module is for.
#                 Required for apache::sys::modfile
#
# $ip::           Required for apache::sys::modfile.
#
# $port::         Required for apache::sys::modfile.
#
# $docroot::      Document root.
#                 Is automaticly filled in if pushed through apache::vhost.
#
# $_automated::   This is a variable that is used under the hood.
#                 If a mod is enabled directly through apache::vhost (no
#                 specific apache::vhost::mod::* is defined) this is set
#                 to true. Required for apache::sys::modfile.
#
# $_header::      For some modules, a header is required which should
#                 be included only once for all mods of the same type.
#                 When using the mods parameter of a vhost, this will
#                 be done automaticly for an included mod type or only for
#                 the first if an array of a certain mod type is given.
#
# $comment::      Custom comment to add before the statements.
#
# $location::     Location to serve the server info on.
#                 Defaults to /server-info
#
# $allow_order::  Should be either deny,allow or allow,deny.
#                 See: http://httpd.apache.org/docs/2.2/howto/access.html
#
# $allow_from::   Hosts, ips, ... where access should be allowed from.
#                 Defaults to 'All'
#                 See: http://httpd.apache.org/docs/2.2/howto/access.html
#
# $deny_from::    Hosts,ips, ... where access should be disallowed from.
#                 Defaults to '' (empty).
#                 See: http://httpd.apache.org/docs/2.2/howto/access.html.
#
#
# === Optional Parameters:
#
# Any other parameters you wish to use for your module. If you add other
# parameters, make sure to add the required parameters without default
# values before those with default parameters. There is no shame in
# changing the order of the Required Parameters.
#
# === Actions:
#
# Creates a apache::sys::modfile for the vhost that has been selected.
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

