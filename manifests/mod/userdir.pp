# == Class: apache::mod::userdir
#
# Include mod_userdir support
#
# === Todo:
#
# TODO: Update documentation
#
class apache::mod::userdir (
  $notify_service = undef,
  $ensure         = 'present',
) {

  ## Cleanup default definitions.

  apache::augeas::rm {'archlinux-include-httpd-userdir.conf':
    key   => 'Include',
    value => 'conf/extra/httpd-userdir.conf',
  }

  apache::augeas::rmnode {'centos-ifmodule-userdir':
    type  => 'IfModule',
    value => 'mod_userdir.c',
  }

  apache::config::loadmodule {'userdir':
    ensure         => $ensure,
    notify_service => $notify_service,
  }

}
