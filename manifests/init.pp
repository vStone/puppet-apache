import 'packages.pp'
import 'config.pp'
import 'service.pp'
import 'mod/passenger.pp'
import 'mod/prefork.pp'
import 'mod/php.pp'
import 'mod/xsendfile.pp'
import 'nginx/*'

class apache (
	$apache = $::operatingsystem ? {
		default => 'httpd',
		debian => 'apache2',
	},
	$root = $::operatingsystem ? {
		default => '/etc/httpd',
		debian => '/etc/apache2',
	},
	$user = $::operatingsystem ? {
		default => 'apache',
		archlinux => 'http',
		debian => 'www-data',
	},
	$group = $::operatingsystem ? {
		default => 'apache',
		archlinux => 'http',
		debian => 'www-data',
	},
	$devel = 'no'
) {
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
