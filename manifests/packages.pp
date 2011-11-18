class apache::packages {
	@package {
		'apache':
			ensure => installed,
			name => $operatingsystem ? {
				default => "httpd",
				archlinux => 'apache',
				/Debian|Ubuntu/ => "apache2",
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

		'mod_ssl':
			ensure => installed,
			name => 'mod_ssl',
			notify => Service['apache'];
	}

	realize(Package['apache'])
	if $apache::devel == 'yes' {
		if $::operatingsystem != 'archlinux' {
			realize(Package['apache-devel'])
		}
	}
	if $apache::ssl == 'yes' {
		if $::operatingsystem == 'centos' {
			realize(Package['mod_ssl'])
		}
	}
}
