# = Definition: apache::vhost::mod::webdav
#
# == Parameters:
#
# Your definition should always take the following parameters. When
# using the mods parameter from vhost, these get set automaticly.
#
# $vhost::      Defined what vhost this module is for.
#               Required for apache::vhost::modfile
#
# $ip::         Required for apache::vhost::modfile.
#
# $port::       Required for apache::vhost::modfile.
#
# $ensure::     Disable or enable this mod. This will/should remove the config
#               file. Required for apache::vhost::modfile.
#
# $location::   Location of files to share, relative to the vhost docroot.
#               Defaults to '/'.
#
# $allow::      Parameters to pass to a 'Require' statement inside the webdav
#               location. The 'Require' statement will only be present when the
#               'allow' parameter is set to something other than ''. This is
#               mostly useful to restrict access to a certain location to a
#               specific person or group.
#
# == Actions:
#
# Creates a apache::vhost::modfile for the vhost that has been selected.
#
# == Sample Usage:
#
define apache::vhost::mod::webdav (
  $docroot,
  $vhost,
  $ensure        = 'present',
  $ip            = undef,
  $port          = '80',
  $order         = undef,
  $_automated    = false,
  $_header       = true,

  $location      = '/',
  $allow         = undef
) {


  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/webdav.erb')

  apache::vhost::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    nodepend => $_automated,
    content  => $definition,
    order    => $order,
  }
}

