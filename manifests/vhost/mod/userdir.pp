# == Definition: apache::vhost::mod::userdir
#
# Setup mod_userdir in a vhost
#
# === Parameters:
#
# Some basic parameters that are always present in a module are not
# documented. See the apache::vhost::mod::dummy for an explanation on them.
#
#
# [*rewrite_cond*] The rewrite condition to use. Standard apache syntax.
#                 For now only one string is supported, array support
#                 may be added at a later time.
#
# [*rewrite_rule*] The rewrite rule to use when the rewrite_cond matches.
#                 For now only one string is supported, array support
#                 may be added at a later time.
#
#
# === Todo:
#
# * TODO: Update documentation
#
define apache::vhost::mod::userdir (
  $vhost,
  $notify_service = undef,
  $ensure         = 'present',
  $ip             = undef,
  $port           = undef,
  $docroot        = undef,
  $order          = undef,
  $_automated     = false,
  $_header        = true,
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
