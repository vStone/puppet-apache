class apache::config::listen {

  $confd = 'listen.d'
  $order = '00'
  $includes = '*.conf'
  $purge  = true

  apache::confd {'listen':
    confd        => 'listen.d',
    order        => $order,
    load_content => '',
    warn_content => '',
    includes     => $includes,
    purge        => $purge,
  }

}
