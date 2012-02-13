# = Definition: apache::vhost::mod::passenger
#
# Enable a passenger configuration in this vhost.
#
# == Required Parameters:
#
# Your definition should always take the following parameters. When
# using the mods parameter from vhost, these get set automaticly.
#
# $ensure::     Disable or enable this mod. This will/should remove the config
#               file. Required for apache::vhost::modfile.
#
# $vhost::      Defined what vhost this module is for.
#               Required for apache::vhost::modfile
#
# $ip::         Required for apache::vhost::modfile.
#
# $port::       Required for apache::vhost::modfile.
#
# $docroot::    Document root.
#               Is automaticly filled in if pushed through apache::vhost.
#
# $automated::  This is a variable that is used under the hood.
#               If a mod is enabled directly through apache::vhost (no
#               specific apache::vhost::mod::* is defined) this is set
#               to true. Required for apache::vhost::modfile.
#
#
# == Optional Parameters:
#
#
# == Actions:
#
# Creates a apache::vhost::modfile for the vhost that has been selected.
#
# == Sample Usage:
#
define apache::vhost::mod::passenger (
  $vhost,
  $ip           = undef,
  $port         = '80',
  $ensure       = 'present',
  $docroot      = undef,
  $automated    = false,
  $app_root     = undef,
  $global_queue = undef
) {


  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/dummy.erb')

  apache::vhost::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    nodepend => $automated,
    content  => $definition,
  }
}

