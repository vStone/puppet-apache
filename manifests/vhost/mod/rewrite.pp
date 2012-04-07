# = Definition: apache::vhost::mod::rewrite
#
# Setup mod_rewrite in a vhost
#
# == Parameters:
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
# $automated::    Only used when including the mod through the mods param
#                 of the corresponding vhost. This automagically sets the
#                 vhost name and some more params. Also removes the need
#                 for a title.
define apache::vhost::mod::rewrite (
  $rewrite_cond,
  $rewrite_rule,
  $vhost,
  $ensure        = 'present',
  $ip            = undef,
  $port          = undef,
  $automated     = false,
) {

  $definition = template('apache/vhost/mod/rewrite.erb')

  apache::vhost::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    content  => $definition,
    nodepend => $automated,
  }

}
