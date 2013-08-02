# == Definition: apache::vhost::mod::manager
#
# Enable a cluster configuration in this vhost.
#
# === Required Parameters:
#
#
# Some basic parameters that are always present in a module are not
# documented. See the apache::vhost::mod::dummy for an explanation on them.
#
# [*location*]
#
# [*allow_order*]
#
# [*allow_from*]
#
# [*deny_from*]
#
# [*max_mcmp_max_mess_size*]
#
# [*manager_balancer_name*]
#
# [*check_nonce*]
#
# [*allow_display*]
#
# [*allow_cmd*]
#
# [*reduce_display*]
#
# === Todo:
#
# TODO: Implement remaining parameters
# TODO: Update documentation
# TODO: validate parameters
#
define apache::vhost::mod::manager (
  $vhost,
  $notify_service       = undef,
  $ensure               = 'present',
  $ip                   = undef,
  $port                 = '80',
  $docroot              = undef,
  $order                = undef,
  $_automated           = false,
  $_header              = true,
  $comment              = undef,
  $content              = undef,

  $location             = 'mod_cluster-manager',
  $allow_order          = 'Deny,Allow',
  $allow_from           = '127.0.0.1',
  $deny_from            = undef,
  $max_mcmp_max_mess_size = undef,
  $manager_balancer_name = undef,
  $check_nonce          = undef,
  $allow_display        = undef,
  $allow_cmd            = undef,
  $reduce_display       = undef
) {


  case $allow_order {
    /^(?i:deny,allow)$/: {}
    /^(?i:allow,deny)$/: {}
    default: {
      fail( template('apache/msg/directive-allow-order-fail.erb') )
    }
  }

  case $max_mcmp_max_mess_size {
    /^[0-9]+$/: {}
    undef: {}
    default: {
      fail("apache::vhost::mod_manager parameter max_mcmp_max_mess_size is not a number: '${max_mcmp_max_mess_size}'")
    }
  }
  case $check_nonce {
    /(?i:on|off)/: {}
    true,false,undef: {}
    default: {
      fail("apache::vhost::mod_manager parameter check_nonce must be one of 'on','off', true or false. Provided: '${check_nonce}'")
    }
  }
  case $allow_display {
    /(?i:on|off)/: {}
    true,false,undef: {}
    default: {
      fail("apache::vhost::mod_manager parameter allow_display must be one of 'on','off', true or false. Provided: '${allow_display}'")
    }
  }
  case $allow_cmd {
    /(?i:on|off)/: {}
    true,false,undef: {}
    default: {
      fail("apache::vhost::mod_manager parameter allow_cmd must be one of 'on','off', true or false. Provided: '${allow_cmd}'")
    }
  }
  case $reduce_display {
    /(?i:on|off)/: {}
    true,false,undef: {}
    default: {
      fail("apache::vhost::mod_manager parameter reduce_display must be one of 'on','off', true or false. Provided: '${reduce_display}'")
    }
  }

  ## Generate the content for your module file:
  $manager = template('apache/vhost/mod/manager.erb')

  apache::sys::modfile {$title:
    ensure         => $ensure,
    vhost          => $vhost,
    ip             => $ip,
    port           => $port,
    nodepend       => $_automated,
    content        => $manager,
    order          => $order,
    notify_service => $notify_service,
  }
}

