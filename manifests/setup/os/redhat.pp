# == Class: apache::setup::os::redhat
#
# Specific setup instructions for CentOS/RedHat
#
class apache::setup::os::redhat {

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

