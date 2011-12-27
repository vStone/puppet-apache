define apache::vhost::config::simple (
  $ensure,
  $content,
  $order
) {

  $file_base= "apache-vhost-config-simple-${title}"


  apache::confd::file {$file_base:
    confd           => $apache::config::vhost::confd,
    order           => $order,
    content         => $content,
    file_name       => "${name}.conf",
    use_config_root => true,
  }

}
