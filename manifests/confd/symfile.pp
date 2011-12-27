# == Definition: apache::confd::symfile
#
# Helper definition for confd style folders
#
# === Parameters:
#  $confd:
#     Subfolder in conf.d directory.
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
define apache::confd::symfile (
  $confd,
  $enabled    = true,
  $link_name  = "${title}.conf",
  $file_name  = "${title}_configuration",
  $order      = undef,
  $content    = ''
) {

  case $order {
    undef:    {
      $fname = $file_name
      $lname = $link_name
    }
    default:  {
      $fname = "${order}_${file_name}"
      $lname = "${order}_${link_name}"
    }
  }

  file {$title:
    ensure  => present,
    path    => "${apache::params::confd}/${confd}/$fname",
    notify  => Service['apache'],
    content => $content,
  }

  file {"${title}-symlink":
    path    => "${apache::params::confd}/${confd}/${lname}",
    target  => "${apache::params::confd}/${confd}/$fname",
  }

  if $enabled {
    File["${title}-symlink"] { ensure => link }
  } else {
    File["${title}-symlink"] { ensure => absent }
  }

}
