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
    confd           => $apache::setup::vhost::confd,
    order           => $order,
    content         => $content,
    file_name       => "${name}_configuration",
    link_name       => "${name}.conf",
    use_config_root => $apache::setup::vhost::use_config_root,
  }

}
