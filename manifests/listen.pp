# Definition: apache::listen
#
# Instruct apache to listen to this port.
#
# Parameters:
#  $ip:
#
#  $port:
#
#  $comment:

define apache::listen (
  $ip = undef,
  $port = undef,
  $comment = ''
) {

  require apache::params
  require apache::config::listen

  $listen_port = $port ? {
    undef   => $name,
    default => $port,
  }


  $listen = $ip ? {
    undef   => $listen_port,
    default => "${ip}_${listen_port}"
  }
  if $title != $listen {
    fail("Please use '${listen}' as title for the apache::listen resource defined with ip: ${ip} and port: ${listen_port}")
  }

  if $comment != '' {
    $content_comment = "# ${comment}
"
  } else {
    $content_comment = ''
  }

  if $ip == undef {
    $content_listen = 'Listen '
  } else {
    $content_listen = "Listen ${ip}:"
  }

  $content = "${content_comment}${content_listen}${listen_port}
"

  $fname = "listen_${ip}_${listen_port}"

  apache::confd::file {$fname:
    confd     => $apache::config::listen::confd,
    content   => $content,
  }

}
