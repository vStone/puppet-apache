# == Class: apache::logrotate
#
# Generate logrotate scripts for your vhost logs matching the
# currently selected config style.
#
class apache::logrotate (
  $logrotate_d = $::apache::params::logrotate_d,
  $mask        = undef,
  $options     = ['missingok','notifempty','sharedscripts','compress','delaycompress'],
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
