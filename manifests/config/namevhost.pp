class apache::config::namevhost {

  $confd = 'namevhost.d'
  $order = '01'
  $includes = '*.conf'
  $purge  = true

  apache::confd {'namevhost':
    confd        => $apache::config::namevhost::confd,
    order        => $apache::config::namevhost::order,
    load_content => '',
    warn_content => '',
    includes     => $apache::config::namevhost::includes,
    purge        => $apache::config::namevhost::purge,
  }

}
