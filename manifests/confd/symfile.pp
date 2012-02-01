# == Definition: apache::confd::symfile
#
# Helper definition for confd style folders
#
# === Parameters:
#  $confd:
#     Subfolder in conf.d directory. If use_config_root is enabled, subfolder in apache configuration folder.
#
#  $enabled:
#     If enabled, the symlink to the configuration file will be created.
#
#  $link_name:
#     Path of the link.
#     Defaults to the title with .conf appended.
#
#  $file_name:
#     File name to put in folder (we add order in front if defined).
#     Defaults to the title with _configuration appended.
#
#  $order:
#     Order is prepended to the file to determine the load order.
#
#  $content:
#     Content to put into the file.
#
#  $use_config_root:
#     If enabled, the $confd folder is not placed below the conf.d folder but
#     directly in the apache root.
#
#  $order_linkonly:
#     If enabled, only put the order in the symlink filename. Otherwise,
#     we will also prepend the order to the regular configuration file.
#
# === Created resources:
#
# file {$title: }
#
# file {"${title}-symlink":
#   requires => File[$title],
# }
#
#
define apache::confd::symfile (
  $confd,
  $order            = '10',
  $ensure           = 'enable',
  $link_name        = "${title}.conf",
  $file_name        = "${title}_configuration",
  $content          = '',
  $use_config_root  = false,
  $order_linkonly   = true
) {

  $enabled = $ensure ? {
    /enable|present/ => true,
    true             => true,
    /disable|absent/ => false,
    false            => false,
    default          => true,
  }

  if $order_linkonly {
    $filename = $file_name
  } else {
    $filename = "${order}_${file_name}"
  }
  $linkname = "${order}_${link_name}"

  if $use_config_root {
    $config_root = $apache::params::config_dir
  } else {
    $config_root = $apache::params::confd
  }

  file {$title:
    ensure  => present,
    path    => "${config_root}/${confd}/${filename}",
    notify  => Service['apache'],
    content => $content,
  }

  file {"${title}-symlink":
    path    => "${config_root}/${confd}/${linkname}",
    target  => "${config_root}/${confd}/${filename}",
    require => File[$title],
  }

  if $enabled {
    File["${title}-symlink"] { ensure => 'link' }
  } else {
    File["${title}-symlink"] { ensure => 'absent' }
  }

}
