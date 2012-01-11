#
#
#
define apache::namevhost (
  $comment = ''
) {

  require apache::params
  require apache::setup::listen
  require apache::setup::namevhost


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
    confd     => $apache::setup::namevhost::confd,
    content   => template('apache/confd/namevhost.erb'),
    require   => Apache::Listen[$name],
  }

}
