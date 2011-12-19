class apache::config::listen {

  $confd = 'listen.d'
  $order = '00'
  $includes = '*.conf'
  $purge  = true

  apache::confd {'listen':
    confd        => $apache::config::listen::confd,
    order        => $apache::config::listen::order,
    load_content => '',
    warn_content => '',
    includes     => $apache::config::listen::includes,
    purge        => $apache::config::listen::purge,
  }

}
