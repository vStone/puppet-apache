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
