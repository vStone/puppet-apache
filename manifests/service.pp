class apache::service {
	service { 'apache':
		ensure => running,
		enable => true,
		name => $operatingsystem ? {
			archlinux => 'httpd',
			/Debian|Ubuntu/ => 'apache2',
			Centos => 'httpd',
		},
		require => Package['apache'],
	}
}
