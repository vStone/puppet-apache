define apache::vhost::config::simple::main (
  $ensure,
  $content,
  $order,
  $ip,
  $port
) {

  require apache::vhost::config::simple::params

  apache::confd::symfile {$name:
    ensure          => $ensure,
    confd           => $apache::config::vhost::confd,
    order           => $order,
    content         => $content,
    file_name       => "${name}_configuration",
    link_name       => "${name}.conf",
    use_config_root => $apache::config::vhost::use_config_root,
  }

}
