# == Class: apache::setup::os::centos
#
# Specific setup instructions for CentOS
#
class apache::setup::os::centos {

  include apache::params

  if $::apache::params::ssl == true {
  ## ssl fix
    file {'/etc/httpd/conf.d/ssl.conf':
      ensure  => 'present',
      content => template('apache/config/os/centos6-ssl.conf'),
      require => Package[$::apache::params::package_ssl]
    }
  }

}

