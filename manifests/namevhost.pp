#
#
#
define apache::namevhost (
  $ip = undef,
  $port = undef,
  $comment = ''
) {

  require apache::params
  require apache::config::listen
  require apache::config::namevhost


  $vhost_port = $port ? {
    undef   => $name,
    default => $port,
  }

  if ! ($vhost_port =~ /^[0-9]+$/) {
    fail("${vhost_port} is not a valid port number.")
  }


  case $ip {
    undef:    {
      $ip_def = '*'
      $listen = $vhost_port
    }
    default:  {
      $ip_def = $ip
      $listen = "${ip}_${vhost_port}"
    }
  }

  if $listen != $title {
    fail("Please use '${listen}' as title for the apache::namevhost resource defined with ip: ${ip} and port: ${vhost_port}")
  }

  $fname = "namevhost_${ip}_${vhost_port}"
  apache::confd::file {$fname:
    confd     => $apache::config::namevhost::confd,
    content   => template('apache/confd/confd_namevhost.erb'),
    require   => Apache::Listen[$listen],
  }

}
