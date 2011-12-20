class apache::config::mod {

  $confd = 'mod.d'
  $order = '05'
  $includes = '*.conf'
  $purge  = false

  apache::confd {'mod':
    confd        => $apache::config::mod::confd,
    order        => $apache::config::mod::order,
    load_content => '',
    warn_content => '',
    includes     => $apache::config::mod::includes,
    purge        => $apache::config::mod::purge,
  }

}
