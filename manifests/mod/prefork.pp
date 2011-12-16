class apache::mod::prefork {

  $pkg_name = $::operatingsystem ? {
    /CentOS|RedHat/ => [],
    /Debian|Ubuntu/ => 'apache2-prefork-dev',
    default => [],
  }

  package { $pkg_name:
    ensure  => installed,
    alias   => 'apache_mod_prefork'
  }
}
