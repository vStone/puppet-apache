# == Definition: apache::vhost::mod::rewrite
#
# Setup mod_rewrite in a vhost
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
