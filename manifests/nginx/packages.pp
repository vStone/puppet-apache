class nginx::packages {
	package { nginx:
		ensure => present,
	}
}
