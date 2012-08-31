# = Definition: apache::vhost::config::concat::main
#
# Create the config file using the following style:
#
# A file for each vhost (with all mods in it) and if
# you set ensure to present, a symlink to filename.conf will
# be created that gets included by the apache configuration.
#
# Disabling this vhost will not remove the main vhost configuration
# but rather remove the symlink.
#
define apache::vhost::config::concat::main (
  $ensure,
  $content,
  $content_end,
  $order,
  $ip,
  $port
) {

  require apache::params
  require apache::vhost::config::concat::params

  apache::confd::symfile_concat {$name:
    ensure          => $ensure,
    confd           => $apache::setup::vhost::confd,
    order           => $order,
    content         => $content,
    content_end     => $content_end,
    file_name       => "${name}_configuration",
    link_name       => "${name}.conf",
    use_config_root => $apache::setup::vhost::use_config_root,
    notify          => Service[$apache::params::service_name],
  }

}
