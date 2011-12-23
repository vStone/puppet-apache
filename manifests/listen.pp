# == Definition: apache::listen
#
# Instruct apache to listen to this port.
#
# === Parameters
#  $ip:     Ip to listen to, leave empty for all
#
#  $port:   Port to listen to. Defaults to 80.
#
#  $comment:

define apache::listen (
  $ip = undef,
  $port = undef,
  $comment = ''
) {

  ## Requirements
  require apache::params
  require apache::config::listen

  ####################################
  #### Variable checks & Defaults ####
  ####################################

  ## Listen port defaults to the name (title).
  $listen_port = $port ? {
    undef   => $name,
    default => $port,
  }

  ## Check that our port is numeric and not empty.
  if ! ($listen_port =~ /^[0-9]+$/) {
    fail("${listen_port} is not a valid port number.")
  }

  ## Check if the name is a combination of <ip>_<port>
  # This is mainly used for resolving dependencies.
  $listen = $ip ? {
    undef   => $listen_port,
    default => "${ip}_${listen_port}"
  }
  if $title != $listen {
    fail("Please use '${listen}' as title for the apache::listen resource defined with ip: ${ip} and port: ${listen_port}")
  }


  ####################################
  ####       Prepare content      ####
  ####################################

  ## If there is a comment defined, make sure it is commented out.
  if $comment != '' {
    $content_comment = "# ${comment}
"
  } else {
    $content_comment = ''
  }

  ## If we are listening to an IP, add it to the Listen definition.
  if $ip == undef {
    $content_listen = 'Listen '
  } else {
    $content_listen = "Listen ${ip}:"
  }

  ## And now all of it together
  $content = "${content_comment}${content_listen}${listen_port}
"

  ## Filename for thingie.
  $fname = "listen_${ip}_${listen_port}"

  apache::confd::file {$fname:
    confd     => $apache::config::listen::confd,
    content   => $content,
  }

}
