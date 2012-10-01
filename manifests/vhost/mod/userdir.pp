# == Definition: apache::vhost::mod::userdir
#
# Setup mod_userdir in a vhost
#
# === Parameters:
#
# $rewrite_cond:: The rewrite condition to use. Standard apache syntax.
#                 For now only one string is supported, array support
#                 may be added at a later time.
#
# $rewrite_rule:: The rewrite rule to use when the rewrite_cond matches.
#                 For now only one string is supported, array support
#                 may be added at a later time.
#
# $vhost::        The name of the vhost to work on. This should be
#                 identical to the apache::vhost{NAME:} you have setup.
#
# $docroot::      Document root.
#                 Is automaticly filled in if pushed through apache::vhost.
#
# $ensure::       If ensure is absent, the configuration file will be
#                 removed. Defaults to 'present'.
#
# $ip::           Ip of the vhost to work on. Should be identical to the
#                 apache::vhost instance you have setup. Defaults to '*'
#
# $port::         Port of the vhost to work on. Should be identical to
#                 the apache::vhost instance you have setup.
#                 Defaults to the vhost default.
#
define apache::vhost::mod::userdir (
  $vhost,
  $ensure        = 'present',
  $ip            = undef,
  $port          = undef,
  $docroot       = undef,
  $order         = undef,
  $_automated    = false,
  $_header       = true,
) {

  $definition = template('apache/vhost/mod/userdir.erb')

  apache::sys::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    content  => $definition,
    nodepend => $_automated,
    order    => $order,
  }

}
