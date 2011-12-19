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

  if $comment != '' {
    $content_comment = "# ${comment}
"
  } else {
    $content_comment = ''
  }

  $content_namevhost = "NameVirtualHost ${ip_def}:${vhost_port}"

  $content = "${content_comment}${content_namevhost}
"

  $fname = "namevhost_${ip}_${vhost_port}"

  apache::confd::file {$fname:
    confd     => $apache::config::namevhost::confd,
    content   => $content,
    require   => Apache::Listen[$listen],
  }

}
