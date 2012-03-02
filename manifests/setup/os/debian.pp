# = Class: apache::setup::os::debian
#
# Specific setup instructions for Debian
#
# == Actions:
#
# * Removes the ports.conf file that defines listen directives.
#
class apache::setup::os::debian {

  require apache::params

  $files_to_remove = [
    '/etc/apache2/ports.conf'
  ]

  file {$files_to_remove:
    ensure  => 'absent',
    require => Package[$apache::params::package],
  }

}

