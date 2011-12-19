# == Definition: apache::confd::symfile
#
# Helper definition for confd style folders
#
# === Parameters:
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
#     Content to put into the file. Is used when no template is defined.
#
#  $template:
#     Path to template to use.
#
define apache::confd::file (
  $confd,
  $enabled    = true,
  $link_name  = "${title}.conf",
  $file_name  = "${title}_configuration",
  $order      = undef,
  $content    = '',
  $template   = undef
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
  }

  if $template == undef {
    File[$title] {
      content => $content,
    }
  } else {
    File[$title] {
      template => template($template),
    }
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
