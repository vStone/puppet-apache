class apache::packages {
	package { apache:
		ensure => installed,
		name => $operatingsystem ? {
			archlinux => "apache",
			/Debian|Ubuntu/ => "apache2",
			/Centos|Fedora/ => "httpd",
		},
	}

	service { apache_daemon:
		ensure => running,
		enable => true,
		name => $operatingsystem ? {
			/Debian|Ubuntu/ => 'apache2',
			/Centos|Fedora/ => 'httpd',
		},
		require => Package['apache'],
	}

	package { 'apache-dev':
		ensure => installed,
		name => $operatingsystem ? {
			/Debian|Ubuntu/ => 'apache2-threaded-dev',
			/Centos|Fedora/ => 'httpd-devel',
		},
	}
}
