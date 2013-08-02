# == Class: apache::logrotate
#
# Generate logrotate scripts for your vhost logs matching the
# currently selected config style.
#
# === Parameters:
#
# [*logrotate_d*]
#   Location of the logrotation.d folder.
#   Defaults to distro specific.
#
# [*mask*]
#   The file mask to operate on.
#   Defaults to the vhost log dir/*/*log.
#
# [*options*]
#   An array of options to add.
#   Defaults to 'missingok','notifempty','sharedscripts','delaycompress'.
#
# [*reload_command*]
#   The reload command to use after logrotation.
#   Defaults to distro specific.
#
# === Usage:
#
#   include apche::logrotate
#
#
class apache::logrotate (
  $logrotate_d = $::apache::params::logrotate_d,
  $mask        = undef,
  $options     = ['missingok','notifempty','sharedscripts','delaycompress'],
  $reload_command = $::apache::params::service_reload_command
) {
  require apache::params

  case $mask {
    default: { $_mask = $mask }
    undef: {
      $_mask = "${::apache::params::vhost_log_dir}/*/*log"
    }

  }

  file {"${logrotate_d}/httpd-vhosts":
    ensure  => 'present',
    content => template("${module_name}/logrotate-vhosts.erb"),
  }

}
