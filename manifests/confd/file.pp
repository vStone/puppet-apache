# Definition: apache::confd::file
#
# Helper definition for confd style folders
#
# Parameters:
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
  $file_name     = "${title}.conf",
  $order    = undef,
  $content  = '',
  $template = undef
) {

  $fname = $order ? {
    undef   => $file_name,
    default => "${order}_${file_name}"
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

}
