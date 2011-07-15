import 'packages.pp'
import 'config.pp'
import 'service.pp'
import 'mod/passenger.pp'
import 'mod/prefork.pp'
import 'mod/php.pp'
import 'mod/xsendfile.pp'

class apache {
	include apache::packages
	include apache::config
	include apache::service

	Class['apache::packages'] -> Class['apache::config'] -> Class['apache::service']
}
