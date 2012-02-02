# = Definition: apache::vhost::mod::dummy
#
# This dummy is an example on how to add your own vhost mod.
#
# == Required Parameters:
#
# Your definition should always take the following parameters. When
# using the mods parameter from vhost, these get set automaticly.
#
# $vhost::      Defined what vhost this module is for. Required for apache::vhost::modfile
#
# $ip::         Required for apache::vhost::modfile.
#
# $port::       Required for apache::vhost::modfile.
#
# $ensure::     Disable or enable this mod. This will/should remove the config
#               file. Required for apache::vhost::modfile.
#
# $automated::  This is a variable that is used under the hood. If a mod is enabled
#               directly through apache::vhost (no specific apache::vhost::mod::* is defined)
#               this is set to true. Required for apache::vhost::modfile.
#
#
# == Optional Parameters:
#
# Any other parameters you wish to use for your module. If you add other parameters,
# make sure to add the required parameters without default values before those with
# default parameters. There is no shame in changing the order of the Required Parameters.
#
# == Actions:
#
# Creates a apache::vhost::modfile for the vhost that has been selected.
#
# == Sample Usage:
#
define apache::vhost::mod::dummy (
  $vhost,
  $ip           = undef,
  $port         = '80',
  $ensure       = 'present',
  $automated    = true
) {


  ## Generate the content for your module file:
  $definition = '## You probably want to use a template here'

  apache::vhost::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    nodepend => $automated,
    content  => $definition,
  }
}

