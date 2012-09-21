# == Class: apache::vhost::config::concat::params
#
# === Todo:
#
# TODO: Update documentation
#
class apache::vhost::config::concat::params {

  ## This is the path mod should use to put their additional configuration in.
  $include_path = ''
  $mod_path = ''

}
