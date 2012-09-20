class apache::setup::namevhost {

  $confd = 'namevhost.d'
  $order = '01'
  $includes = '*.conf'
  $purge  = true

  ## Remove listen directives in the main http configuration if we define them.
  # You can still add aditional listeners but if they overlap :)
  augeas{'apache-setup-namevhost-config':
    lens    => 'Httpd.lns',
    incl    => $::apache::params::config_file,
    context => "/files${::apache::params::config_file}",
    changes => "rm directive[ . = 'NameVirtualHost' ]",
  }

  apache::confd {'namevhost':
    confd        => $apache::setup::namevhost::confd,
    order        => $apache::setup::namevhost::order,
    load_content => '',
    warn_content => '',
    includes     => $apache::setup::namevhost::includes,
    purge        => $apache::setup::namevhost::purge,
  }

}
