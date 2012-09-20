class apache::setup::listen {

  $confd = 'listen.d'
  $order = '00'
  $includes = '*.conf'
  $purge  = true


  ## Remove listen directives in the main http configuration if we define them.
  # You can still add aditional listeners but if they overlap :)
  augeas{'apache-setup-listen-config':
    lens    => 'Httpd.lns',
    incl    => $::apache::params::config_file,
    context => "/files${::apache::params::config_file}",
    changes => "rm directive[ . = 'Listen' ]",
  }

  apache::confd {'listen':
    confd        => $apache::setup::listen::confd,
    order        => $apache::setup::listen::order,
    load_content => '',
    warn_content => '',
    includes     => $apache::setup::listen::includes,
    purge        => $apache::setup::listen::purge,
  }

}
