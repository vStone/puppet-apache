class apache::config {
  require apache::params

  file { 'apache-confdir':
      ensure  => directory,
      path    => "${apache::params::config_dir}/conf.d",
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
  }

  file { 'apache.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      path    => $apache::params::config_path,
      content => template($apache::params::config_template),
      notify    => Service['apache'],
      require   => File['apache-confdir'];
  }

}
