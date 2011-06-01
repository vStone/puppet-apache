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

class apache_config {
	file { 'apache.conf':
		ensure => present,
		owner => root,
		group => root,
		mode => 0644,
		name => $operatingsystem ? {
			/Debian|Ubuntu/ => '/etc/apache2/apache2.conf',
			/Centos|Fedora/ => '/etc/httpd/conf/httpd.conf',
		},
		source => 'puppet:///config/httpd',
		notify => Service['apache'],
	}
}

class apache_mod_passenger {
	package { passenger:
		ensure => installed,
		name => $operatingsystem ? {
			/Debian|Ubuntu/ => "libapache2-mod-passenger",
			/Centos|Fedora/ => "passenger",
		},
		provider => $operatingsystem ? {
			/Debian|Ubuntu/ => 'apt',
			/Centos|Fedora/ => 'gem',
		},
		require => Package['apache'],
	}
}

class apache_mod_php {
	package { "apache_mod_php":
		ensure => installed,
		name => $operatingsystem ? {
			/Debian|Ubuntu/ => "libapache2-mod-php",
		},
		require => Package["apache"],
		notify => Service["apache"],
	}
}

class apache_prefork {
	package { "apache2-prefork-dev":
		ensure => installed,
	}
}

class apache_mod_xsendfile {
	package { "mod-xsendfile":
		ensure => installed,
		name => $operatingsystem ? {
			/Debian|Ubuntu/ => "libapache2-mod-xsendfile",
			/Centos|Fedora/ => "mod_xsendfile",
		},
		require => Class["repos_centos"],
	}
}
