class apache::config {
	file { 'apache.conf':
		ensure => present,
		owner => root,
		group => root,
		mode => 0644,
		name => $operatingsystem ? {
			/Debian|Ubuntu/ => '/etc/apache2/apache2.conf',
			Centos => '/etc/httpd/conf/httpd.conf',
		},
		content => $operatingsystem ? {
			'Centos' => $operatingsystemrelease ? {
				'6.0' => template('apache/apache.conf-centos6.erb'),
				'*' => template('apache/apache.conf'),
			},
			'*' => template('apache/apache.conf'),
		},
		notify => Service['apache'],
	}
}
