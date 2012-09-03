# = Definition: apache::vhost::config::concat::mod
#
# Helper file wrapper for extra mods for a certain vhost.
# This will be added to the vhost configuration using the
# concat module.
#
# == Parameters:
#
# $vhost:
#
# $ensure:
#
define apache::vhost::config::concat::mod (
  $vhost,
  $ip       = undef,
  $port     = '80',
  $ensure   = 'present',
  $content  = '',
  $nodepend = false
) {

  ## Get the configured configuration style.
  require apache::vhost::config::concat::params

  $fragment_name = "${vhost}_mod_${name}"

  concat::fragment{$fragment_name:
    ensure  => $ensure,
    target  => $vhost,
    content => $content,
  }
  #  if $nodepend == false {
  #  Concat::Fragment[$fragment_name] {
  #    require   => Apache::Vhost[$vhost],
  #  }
  #}

}
