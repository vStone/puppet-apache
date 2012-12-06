# == Definition: apache::sys::config::concat::main
#
# === Todo:
#
# TODO: Update documentation
#
define apache::sys::config::debian_concat::main (
  $ensure,
  $notify_service,
  $content,
  $content_end,
  $order,
  $ip,
  $port
) {

  require apache::params
  require apache::sys::config::concat::params

  apache::confd::symfile_concat {$name:
    ensure          => $ensure,
    confd           => 'sites-available',
    confd_link      => 'sites-enabled',
    order           => $order,
    content         => $content,
    content_end     => $content_end,
    file_name       => "${name}_configuration",
    link_name       => "${name}.conf",
    use_config_root => $::apache::setup::vhost::use_config_root,
    notify_service  => $notify_service,
  }

}
