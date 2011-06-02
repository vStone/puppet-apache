class apache::config {
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
