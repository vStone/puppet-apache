# == Definition: apache::namevhost
#
#   Configure the apache service to enable name based vhosts on
#   a certain (ip/)port
#
# === Parameters
#
#   $comment:     Add a comment in the configuration file.
#
# === Usage:
#
#  On all ips:
#
#     apache::namevhost {'80':}
#
#  On a specific ip:
#
#     apache::namevhost {'10.0.0.1_80':}
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
    confd          => $apache::setup::namevhost::confd,
    content        => template('apache/confd/namevhost.erb'),
    require        => Apache::Listen[$name],
    notify_service => $::apache::params::notify_service,
  }

}
