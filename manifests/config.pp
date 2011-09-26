class apache::config {
	file {
		"$apache::root/conf.d":
			ensure => directory,
			owner => 'root',
			group => 'root',
			mode => '0755';

		'apache.conf':
			ensure => present,
			owner => root,
			group => root,
			mode => 0644,
			name => $operatingsystem ? {
				default => '/etc/httpd/conf/httpd.conf',
				/Debian|Ubuntu/ => '/etc/apache2/apache2.conf',
			},
			content => $operatingsystem ? {
				archlinux => template('apache/archlinux-apache.conf.erb'),
				'Centos' => $operatingsystemrelease ? {
					'6.0' => template('apache/centos6-apache.conf.erb'),
					'*' => template('apache/centos-apache.conf.erb'),
				},
				default => template('apache/debian-apache.conf.erb'),
			},
			notify => Service['apache'],
			require => File["$apache::root/conf.d"];
	}
}
