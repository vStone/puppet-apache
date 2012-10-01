# == Class: apache::setup::mod
#
# === Todo:
#
# TODO: Update documentation
#
class apache::setup::mod {

  $confd = 'mod.d'
  $order = '05'
  $includes = '*.conf'
  $purge  = false

  apache::confd {'mod':
    confd        => $::apache::setup::mod::confd,
    order        => $::apache::setup::mod::order,
    load_content => '',
    warn_content => '',
    includes     => $::apache::setup::mod::includes,
    purge        => $::apache::setup::mod::purge,
  }

}
