define apache::vhost::config::simple (
  $ensure,
  $content,
  $order
) {

  $file_base= "apache-vhost-config-simple-${title}"

  apache::confd::symfile {$file_base:
    ensure          => $ensure,
    confd           => $apache::config::vhost::confd,
    order           => $order,
    content         => $content,
    file_name       => "${name}_configuration",
    link_name       => "${name}.conf",
    use_config_root => $apache::config::vhost::use_config_root,
  }

}
