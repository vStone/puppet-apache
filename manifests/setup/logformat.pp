# == Class: apache::setup::logformat
#
# === Todo:
#
# TODO: Update documentation
#
class apache::setup::logformat {

  $confd    = 'logformat.d'
  $order    = '01'
  $includes = '*.conf'
  $purge    = true

  apache::confd {'logformat':
    confd        => $::apache::setup::logformat::confd,
    order        => $::apache::setup::logformat::order,
    load_content => '',
    warn_content => '',
    includes     => $::apache::setup::logformat::includes,
    purge        => $::apache::setup::logformat::purge,
  }

}
