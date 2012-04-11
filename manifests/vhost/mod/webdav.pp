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
# $automated::  This is a variable that is used under the hood. If a mod is
#               enabled directly through apache::vhost - no specific
#               apache::vhost::mod::* is defined - this is set to true.
#               Required for apache::vhost::modfile.
#
# $location::   Location of files to share, relative to the vhost docroot.
#               Defaults to '/'.
#
# == Actions:
#
# Creates a apache::vhost::modfile for the vhost that has been selected.
#
# == Sample Usage:
#
define apache::vhost::mod::webdav (
  $vhost,
  $docroot,
  $ip        = undef,
  $port      = '80',
  $ensure    = 'present',
  $automated = false,
  $location  = '/',
  $allow     = ''
) {


  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/webdav.erb')

  apache::vhost::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    nodepend => $automated,
    content  => $definition,
  }
}

