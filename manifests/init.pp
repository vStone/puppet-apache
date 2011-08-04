import 'packages.pp'
import 'config.pp'
import 'service.pp'
import 'mod/passenger.pp'
import 'mod/prefork.pp'
import 'mod/php.pp'
import 'mod/xsendfile.pp'
import 'nginx/*'

class apache {
	include apache::packages
	include apache::config
	include apache::service

	Class['apache::packages'] -> Class['apache::config'] -> Class['apache::service']
}

class nginx {
	include nginx::packages
	include nginx::service
	include nginx::config

	Class['nginx::packages'] -> Class['nginx::config'] -> Class['nginx::service']
}
