class apache::service {
	service { 'apache-daemon':
		ensure => running,
		enable => true,
		name => $operatingsystem ? {
			/Debian|Ubuntu/ => 'apache2',
			/Centos|Fedora/ => 'httpd',
		},
		require => Package['apache'],
	}
}
