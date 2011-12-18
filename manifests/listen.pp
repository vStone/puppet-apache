define apache::listen (
  $ip = undef,
  $port = 80,
  $comment = ''
) {

  require apache::params
  require apache::config::listen

  if $comment != '' {
    $content_comment = "# ${comment}
"
  } else {
    $content_comment = ''
  }

  if $ip == undef {
    $content_listen = "Listen "
  } else {
    $content_listen = "Listen ${ip}:"
  }

  $content = "${content_comment}${content_listen}${port}
"

  $fname = "listen_${ip}_${port}"

  file { $fname:
    ensure  => present,
    path    => "${apache::params::confd}/listen.d/${fname}.conf",
    content => $content,
  }

}
