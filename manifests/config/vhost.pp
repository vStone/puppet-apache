class apache::config::vhost {

  $confd = 'vhost.d'
  $order = '10'
  $includes = ['*.conf', '*/*.conf' ]
  $purge  = false

  apache::confd {'vhost':
    confd           => $apache::config::vhost::confd,
    order           => $apache::config::vhost::order,
    load_content    => '',
    warn_content    => '',
    includes        => $apache::config::vhost::includes,
    purge           => $apache::config::vhost::purge,
    use_config_root => true,
  }

}
