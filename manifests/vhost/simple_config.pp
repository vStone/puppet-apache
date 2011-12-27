define apache::vhost::simple_config (
  $order,
  $content,
  $ensure
) {




  $file_base= "apache-vhost-simple_config-${name}"

  apache::confd::file {$fname: }

}
