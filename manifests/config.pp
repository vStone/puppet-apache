class apache::config {
	file { 'apache.conf':
		ensure => present,
		owner => root,
		group => root,
		mode => 0644,
		name => $operatingsystem ? {
			archlinux => '/etc/httpd/conf/httpd.conf',
			/Debian|Ubuntu/ => '/etc/apache2/apache2.conf',
			Centos => '/etc/httpd/conf/httpd.conf',
		},
		content => $operatingsystem ? {
			'Centos' => $operatingsystemrelease ? {
				'6.0' => template('apache/centos6-apache.conf.erb'),
				'*' => template('apache/centos-apache.conf.erb'),
			},
			default => template('apache/debian-apache.conf.erb'),
		},
		notify => Service['apache'],
	}
}
