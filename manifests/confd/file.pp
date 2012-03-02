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
#     If undefined, no order number will be added to the filename. This is
#     also the default behaviour.
#
#  $content:
#     Content to put into the file.
#
#  $use_config_root:
#     When true, we will create the file in the defined $confd folder
#     in the apache configuration root. Otherwise, its created inside
#     the configured $apache::params::confd.
#
define apache::confd::file (
  $confd,
  $file_name        = "${title}.conf",
  $order            = undef,
  $content          = '',
  $use_config_root  = false,
  $ensure           = 'present'
) {

  $fname = $order ? {
    undef   => $file_name,
    default => "${order}_${file_name}"
  }

  if $use_config_root {
    $config_root = $apache::params::config_dir
  } else {
    ## The confd used here is the GLOBAL conf.d folder.
    $config_root = $apache::params::confd
  }

  file {$title:
    ensure  => $ensure,
    path    => "${config_root}/${confd}/${fname}",
    notify  => Service['apache'],
    content => $content,
  }

}
