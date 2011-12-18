define apache::listen (
  $ip = undef,
  $port = 80,
  $comment = ''
) {

  require apache::params
  require apache::config::listen

  if $ip == undef {
    $content_listen = "# ${comment}
    Listen "
  } else {
    $content_listen = "# ${comment}
    Listen ${ip}:"
  }

  $content = "${content_listen}${port}"

  $fname = "listen_${ip}_${port}"

  file { $fname:
    ensure  => present,
    path    => "${apache::params::confd}/listen.d/${fname}.conf",
    content => $content,
  }

}
