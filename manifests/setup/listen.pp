class apache::setup::listen {

  $confd = 'listen.d'
  $order = '00'
  $includes = '*.conf'
  $purge  = true

  apache::confd {'listen':
    confd        => $apache::setup::listen::confd,
    order        => $apache::setup::listen::order,
    load_content => '',
    warn_content => '',
    includes     => $apache::setup::listen::includes,
    purge        => $apache::setup::listen::purge,
  }

}
