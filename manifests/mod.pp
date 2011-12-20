# == Definition: apache::mod
#
# Load an apache module.
#
# === Parameters
#  $comment:

define apache::mod (
  $comment = ''
) {

  require apache::params
  require apache::config::listen

  $content = "${content_comment}
"

  $fname = "mod_${title}"

  apache::confd::file {$fname:
    confd     => $apache::config::mod::confd,
    content   => $content,
  }

}
