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
