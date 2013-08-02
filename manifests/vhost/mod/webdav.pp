# == Definition: apache::vhost::mod::webdav
#
# === Parameters:
#
# Your definition should always take the following parameters. When
# using the mods parameter from vhost, these get set automaticly.
#
# [*location*]
#   Location of files to share, relative to the vhost docroot.
#   Defaults to '/'.
#
# [*allow*]
#   Parameters to pass to a 'Require' statement inside the webdav
#   location. The 'Require' statement will only be present when the
#   'allow' parameter is set to something other than ''. This is
#   mostly useful to restrict access to a certain location to a
#   specific person or group.
#
# === Actions:
#
# Creates a apache::sys::modfile for the vhost that has been selected.
#
# === Sample Usage:
#
#
# === Todo:
#
# TODO: Update documentation
#
define apache::vhost::mod::webdav (
  $docroot,
  $vhost,
  $notify_service = undef,
  $ensure         = 'present',
  $ip             = undef,
  $port           = '80',
  $order          = undef,
  $_automated     = false,
  $_header        = true,
  $comment        = undef,

  $location       = '/',
  $allow          = undef
) {


  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/webdav.erb')

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

