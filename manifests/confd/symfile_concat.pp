# == Definition: apache::confd::symfile_concat
#
# Helper definition for confd style folders
#
# This pretty much does the same as apache::confd::file_concat with
# that exception we always create a file with the provided content
# but the ensure parameter controls wether or not we create a symlink
# to that file.
#
# === Parameters:
#  $confd:
#     Subfolder in conf.d directory. If use_config_root is enabled,
#     subfolder in apache configuration folder.
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
#  $content_end:
#     Optional second part of the configuration file.
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
# TODO: Document.
#
define apache::confd::symfile_concat (
  $confd,
  $notify_service,
  $order            = '10',
  $ensure           = 'enable',
  $link_name        = "${title}.conf",
  $file_name        = "${title}_configuration",
  $content          = '',
  $content_end      = '',
  $use_config_root  = false,
  $order_linkonly   = true
) {

  require concat::setup

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
    $config_root = $::apache::params::config_dir
  } else {
    $config_root = $::apache::params::confd
  }
  $target = "${config_root}/${confd}/${filename}"

  concat {$name:
    path   => $target,
  }
  if $notify_service {
    Concat[$name] {
      notify => Service['apache'],
    }
  }

  concat::fragment{"${title}-main":
    target  => $name,
    order   => '0001',
    content => $content,
  }
  concat::fragment{"${title}-end":
    target  => $name,
    content => $content_end,
    order   => '9999',
  }

  file {"${title}-symlink":
    path    => "${config_root}/${confd}/${linkname}",
    target  => "${config_root}/${confd}/${filename}",
    require => Concat[$name],
  }

  if $enabled {
    File["${title}-symlink"] { ensure => 'link' }
  } else {
    File["${title}-symlink"] { ensure => 'absent' }
  }

}
