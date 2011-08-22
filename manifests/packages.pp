class apache::packages {
	@package {
		'apache':
			ensure => installed,
			name => $operatingsystem ? {
				archlinux => "apache",
				/Debian|Ubuntu/ => "apache2",
				Centos => "httpd",
			},
			notify => Service['apache'];

		'apache-devel':
			ensure => installed,
			name => $operatingsystem ? {
				archlinux => undef,
				/Debian|Ubuntu/ => 'apache2-threaded-dev',
				Centos => 'httpd-devel',
			},
			notify => Service['apache'];
	}

	realize(Package['apache'])
	if $devel == 'yes' {
		realize(Package['apache-devel'])
	}
}
