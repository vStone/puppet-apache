# == Definition: apache::vhost::mod::rewrite
#
# Setup mod_rewrite in a vhost
#
# === Parameters:
#
# Some basic parameters that are always present in a module are not
# documented. See the apache::vhost::mod::dummy for an explanation on them.
#
# [*rewrite_cond*]
#   The rewrite condition to use. Standard apache syntax.
#   For now only one string is supported, array support
#   may be added at a later time.
#
# [*rewrite_rule*]
#   The rewrite rule to use when the rewrite_cond matches.
#   For now only one string is supported, array support
#   may be added at a later time.
#
# === Hiera Support
#
# Since %{VARIABLE_NAME} are pretty common in rewrite rules and hiera
# does not deal with them well (yeah, the normal escape sequence is does not
# work as expected either), you can use %[VARNAME] which will be replaced with
# %{VARNAME} while writing the vhost definition.
#
# === Todo:
#
# TODO: Update documentation
#
define apache::vhost::mod::rewrite (
  $vhost,
  $notify_service = undef,
  $ensure         = 'present',
  $ip             = undef,
  $port           = undef,
  $docroot        = undef,
  $order          = undef,
  $_automated     = false,
  $_header        = true,

  $comment        = undef,
  $rewrite_cond   = [],
  $rewrite_rule   = []
) {

  require apache::mod::rewrite

  $definition = template('apache/vhost/mod/rewrite.erb')

  apache::sys::modfile {$title:
    ensure         => $ensure,
    vhost          => $vhost,
    ip             => $ip,
    port           => $port,
    content        => $definition,
    nodepend       => $_automated,
    order          => $order,
    notify_service => $notify_service,
  }

}
