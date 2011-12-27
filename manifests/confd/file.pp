# == Definition: apache::confd::file
#
#   Helper definition for confd style folders
#
# === Parameters
#
#  $confd:
#     Subfolder in conf.d directory.
#
#  $file_name:
#     File name to put in folder (we add order in front if defined).
#     Defaults to the title with .conf appended.
#
#  $order:
#     Order is prepended to the file to determine the load order.
#
#  $content:
#     Content to put into the file.
#
#  $confd_root:
#     Use this path as confd root folder. (use when use_config_root is false)
#
define apache::confd::file (
  $confd,
  $file_name        = "${title}.conf",
  $order            = undef,
  $content          = '',
  $use_config_root  = false
) {

  $fname = $order ? {
    undef   => $file_name,
    default => "${order}_${file_name}"
  }

  if $use_config_root {
    $config_root = $apache::params::config_dir
  } else {
    $config_root = $apache::params::confd
  }

  file {$title:
    ensure  => present,
    path    => "${config_root}/${confd}/$fname",
    notify  => Service['apache'],
    content => $content,
  }

}
