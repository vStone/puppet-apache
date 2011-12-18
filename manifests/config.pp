class apache::config {
  require apache::params

  file { 'apache-config_file':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      path    => $apache::params::config_file,
      content => template($apache::params::config_template),
      notify  => Service['apache'],
  }

  $apache_confd = 'apache_confd'
  file { $apache_confd:
      ensure  => directory,
      path    => $apache::params::confd,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
  }

  include apache::config::listen

}
