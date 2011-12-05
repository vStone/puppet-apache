class apache::service {
	service { 'apache':
		ensure => running,
		enable => true,
		name => $::operatingsystem ? {
			archlinux => 'httpd',
			/Debian|Ubuntu/ => 'apache2',
			Centos => 'httpd',
		},
		path => $::operatingsystem ? {
			archlinux => '/etc/rc.d',
			default => '/etc/init.d',
		},
		require => Package['apache'],
	}
}
