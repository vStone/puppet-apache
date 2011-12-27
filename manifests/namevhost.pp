#
#
#
define apache::namevhost (
  $comment = ''
) {

  require apache::params
  require apache::config::listen
  require apache::config::namevhost


  ####################################
  #### Variable checks & Defaults ####
  ####################################

  case $name {
    /^[0-9]+$/: {
      $ip = ''
      $port = $name
    }
    /^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)_([0-9]+)/: {
      $ip = $1
      $port = $2
    }
    default : {
      fail ("Could not determine ip and port from ${name}")
    }
  }

  $fname = "namevhost_${ip}_${port}"
  apache::confd::file {$fname:
    confd     => $apache::config::namevhost::confd,
    content   => template('apache/confd/namevhost.erb'),
    require   => Apache::Listen[$name],
  }

}
