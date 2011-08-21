class apache::packages {
	package { apache:
		ensure => installed,
		name => $operatingsystem ? {
			archlinux => "apache",
			/Debian|Ubuntu/ => "apache2",
			Centos => "httpd",
		},
	}

	package { 'apache-dev':
		ensure => installed,
		name => $operatingsystem ? {
			archlinux => undef,
			/Debian|Ubuntu/ => 'apache2-threaded-dev',
			Centos => 'httpd-devel',
		},
	}
}
