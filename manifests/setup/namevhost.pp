class apache::setup::namevhost {

  $confd = 'namevhost.d'
  $order = '01'
  $includes = '*.conf'
  $purge  = true

  apache::confd {'namevhost':
    confd        => $apache::setup::namevhost::confd,
    order        => $apache::setup::namevhost::order,
    load_content => '',
    warn_content => '',
    includes     => $apache::setup::namevhost::includes,
    purge        => $apache::setup::namevhost::purge,
  }

}
