# == Definition: apache::vhost::mod::dummy
#
# This dummy is an example on how to add your own vhost mod.
#
# === Required Parameters:
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
# $_automated:: This is a variable that is used under the hood.
#               If a mod is enabled directly through apache::vhost (no
#               specific apache::vhost::mod::* is defined) this is set
#               to true. Required for apache::vhost::modfile.
#
# $_header::    For some modules, a header is required which should
#               be included only once for all mods of the same type.
#               When using the mods parameter of a vhost, this will
#               be done automaticly for an included mod type or only for
#               the first if an array of a certain mod type is given.
#
# $comment::    Custom comment to add before the statements.
#
# $header::     Array or single header rule.
#
# $requestheader::  Array or single request header rule.
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
# Creates a apache::vhost::modfile for the vhost that has been selected.
#
# === Sample Usage:
#
# === Todo:
#
# TODO: Update documentation
#
define apache::vhost::mod::header (
  $vhost,
  $ensure        = 'present',
  $ip            = undef,
  $port          = '80',
  $docroot       = undef,
  $order         = undef,
  $_automated    = false,
  $_header       = true,

  $comment       = undef,
  $header        = [],
  $requestheader = []
) {


  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/header.erb')

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

