# == Definition: apache::listen
#
# Instruct apache to listen to this port. Name and port are
# from the defined title
#
# === Parameters
#
#  $comment:
#     Additional content that gets added to the listen definition file.
#
#  $name:
#     either a port number or <ip>_<port>
#
# === Example
# apache::listen { '10.0.0.1_80': }
# apache::listen { '80': }
#
define apache::listen (
  $comment = ''
) {

  ## Requirements
  require apache::params
  require apache::config::listen

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

  ####################################
  ####       Prepare content      ####
  ####################################

  if defined(Apache::Listen[$port]) {
    notify {"listen-allinterfaces-warning-${name}":
      message => "Already listening on all interfaces for port ${port}!",
    }
  } else {

    ## Filename for thingie.
    $fname = "listen_${ip}_${listen_port}"

    apache::confd::file {$fname:
      confd         => $apache::config::listen::confd,
      content => template('apache/confd/listen.erb'),
    }
  }

}
