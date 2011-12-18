class apache::config::listen {

  apache::confd {'listen':
    order        => '00',
    load_content => '',
    warn_content => '',
  }

}
