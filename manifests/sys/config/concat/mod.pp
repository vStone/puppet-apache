# == Definition: apache::sys::config::concat::mod
#
# Helper file wrapper for extra mods for a certain vhost.
# This will be added to the vhost configuration using the
# concat module.
#
# === Parameters:
#
# $vhost:
#
# $ensure:
#
#
# === Todo:
#
# TODO: Update documentation
#
define apache::sys::config::concat::mod (
  $vhost,
  $ip       = undef,
  $port     = '80',
  $ensure   = 'present',
  $content  = '',
  $nodepend = false,
  $order    = undef
) {

  ## Get the configured configuration style.
  require apache::sys::config::concat::params

  $fragment_name = "${vhost}_mod_${name}"

  $forder = $order ? {
    undef   => undef,
    default => sprintf('%04d',$order),
  }

  concat::fragment{$fragment_name:
    ensure  => $ensure,
    target  => $vhost,
    content => $content,
    order   => $forder,
  }
  #  if $nodepend == false {
  #  Concat::Fragment[$fragment_name] {
  #    require   => Apache::Vhost[$vhost],
  #  }
  #}

}
