# == Definition: apache::vhost::mod::manager
#
# Enable a cluster configuration in this vhost.
#
# === Required Parameters:
#
# Your definition should always take the following parameters. When
# using the mods parameter from vhost, these get set automaticly.
#
# $ensure::     Disable or enable this mod. This will/should remove the config
#               file. Required for apache::sys::modfile.
#
# $vhost::      Defined what vhost this module is for.
#               Required for apache::sys::modfile
#
# $ip::         Required for apache::sys::modfile.
#
# $port::       Required for apache::sys::modfile.
#
# $docroot::    Document root.
#               Is automaticly filled in if pushed through apache::vhost.
#
# === Optional Parameters:
#
#
# === Actions:
#
# Creates a apache::sys::modfile for the vhost that has been selected.
#
# === Sample Usage:
#
# === Todo:
#
# TODO: Implement remaining parameters
# TODO: Update documentation
# TODO: validate parameters
#
define apache::vhost::mod::manager (
  $vhost,
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
  }
}

