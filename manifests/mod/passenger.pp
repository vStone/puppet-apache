class apache::mod::passenger {
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
