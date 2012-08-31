define apache::vhost::config::simple::main (
  $ensure,
  $content,
  $content_end,
  $order,
  $ip,
  $port
) {

  require apache::params
  require apache::vhost::config::simple::params

  $include_root = $::apache::setup::vhost::confd
  $include_path = $::apache::vhost::config::simple::params::include_path

  $include_blob = "${include_root}/${include_path}${name}_mod_*.include"


  apache::confd::symfile {$name:
    ensure          => $ensure,
    confd           => $apache::setup::vhost::confd,
    order           => $order,
    content         => template('apache/vhost/config/splitconfig_vhost.erb'),
    file_name       => "${name}_configuration",
    link_name       => "${name}.conf",
    use_config_root => $apache::setup::vhost::use_config_root,
    notify          => Service[$apache::params::service_name],
  }

}
