# == Definition: apache::listen
#
# Instruct apache to listen to this port. Name and port are
# determined from the defined title.
#
# === Parameters:
#
# [*name*]
#   Either a single port number or <ip>_<port>
#
# [*comment*]
#   Additional content that gets added to the listen definition file.
#
# === Example:
#
#   apache::listen { '10.0.0.1_80': }
#   apache::listen { '80': }
#
define apache::listen (
  $comment = ''
) {

  ## Requirements
  require apache::params
  require apache::setup::listen

  ####################################
  #### Variable checks & Defaults ####
  ####################################

  case $name {
    /^[0-9]+$/: {
      $do_file = true
      $listen_ip = ''
      $listen_port = $name
    }
    /^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)_([0-9]+)/: {
      $listen_ip = $1
      $listen_port = $2
      if defined(Apache::Listen[$listen_port]) {
        $do_file = false
        notify {"apache-listen-allinterfaces-warning-${name}":
          message => template('apache/msg/listen-allinterfaces-warning.erb'),
        }
      } else {
        $do_file = true
      }

    }
    default : {
      $failmsg = template('apache/msg/listen-fail-ip-port-fromname.erb')
      fail ($failmsg)
    }
  }

  ####################################
  ####       Prepare content      ####
  ####################################

  if $do_file {
    ## Filename for thingie.
    $fname = "listen_${listen_ip}_${listen_port}"

    apache::confd::file {$fname:
      confd          => $::apache::setup::listen::confd,
      content        => template('apache/confd/listen.erb'),
      notify_service => $::apache::params::notify_service,
    }
  }

}
