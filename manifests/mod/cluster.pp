# == Class: apache::mod::cluster
#
# Setup mod_cluster support
#
# == Parameters:
#
#
# $create_balancers::   Possible values are: (use the number or keyword)
#                         0 / All   Create in all VirtualHosts defined in httpd.
#                         1 / No    Don't create balancers (requires at least
#                                   one ProxyPass/ProxyPassMatch to define the
#                                   balancer names)
#                         2 / Main  Create only the main server.
#
# === Todo:
#
# TODO: Add documentation
# TODO: Sanitize parameters
#       - max_* -> integers!
#       - persist_slots -> boolean, on, off
#
#
class apache::mod::cluster (
  $notify_service       = undef,

  $manager_vhost        = true,
  $manager_port         = 80,
  $manager_ip           = undef,
  $manager_servername   = $::fqdn,
  $manager_location     = undef,
  $manager_allow_order  = undef,
  $manager_allow_from   = undef,
  $manager_deny_from    = undef,

  $advertise_vhost      = true,
  $advertise_port       = 6666,
  $advertise_ip         = undef,
  $advertise_servername = $::fqdn,

  $create_balancers     = undef,
  $use_alias            = undef,
  $lbstatus_recal_time  = undef,
  $wait_for_remove      = undef,

  $mem_manager_file     = undef,
  $max_context          = undef,
  $max_node             = undef,
  $max_host             = undef,
  $max_sessionid        = undef,
  $persist_slots        = undef
) {


  require apache::params
  require apache::setup::mod

  #######################################
  #                |
  # ,---.,---.,---.|__/ ,---.,---.,---.
  # |   |,---||    |  \ ,---||   ||---'
  # |---'`---^`---'`   ``---^`---|`---'
  # |                        `---'

  ## Use the mod_cluster module if available
  if defined('::mod_cluster::module') {
    require mod_cluster::module
    case $::mod_cluster::module::id {
      default, undef: {
        $mod_id = $::mod_cluster::module::id
        fail ("The selected module (${mod_id}) is not supported by this module.")
      }
      'unifiedpost-puppet-module': {
        include mod_cluster
      }
    }
  } else {

    ## Fallback, do it ourselves for now.
    case $::operatingsystem {
      /(?i:centos|redhat)/: {
        $pkg_name = 'mod_cluster'
      }
      default: {
        fail('Your operatingsystem is not supported by apache::mod::cluster')
      }
    }

    apache::sys::modpackage { 'cluster':
      package        => $pkg_name,
      notify_service => $notify_service,
    }
  }

  #######################################
  #           |
  # ,---.,---.|--- .   .,---.
  # `---.|---'|    |   ||   |
  # `---'`---'`---'`---'|---'
  #                     |

  ## LoadModule statements that are required and/or should NOT be present.
  apache::config::loadmodule {'slotmem': }
  apache::config::loadmodule {'manager': }
  apache::config::loadmodule {'proxy_cluster': }
  apache::config::loadmodule {'advertise': }
  apache::config::loadmodule {'proxy_balancer': ensure => 'absent', }


  case $create_balancers {
    /^(?i:0|all)$/:   { $createbalancers = 0 }
    /^(?i:1|no)$/:    { $createbalancers = 1 }
    /^(?i:2|main)$/:  { $createbalancers = 2 }
    undef:            { $createbalancers = undef }
    default: {
      fail ("Unrecognized value for create_balancers. Must be one of 0,1,2,all,no,main. given: '${create_balancers}'")
    }
  }
  case $use_alias {
    /^(?i:1|yes|on)$/:  { $usealias = 1 }
    /^(?i:0|no|off)$/:  { $usealias = 0 }
    true:               { $usealias = 1 }
    false:              { $usealias = 0 }
    undef:              { $usealias = undef }
    default: {
      fail('Unrecognized value for use_alias. Must be one of 0,1,true or false.')
    }
  }
  case $lbstatus_recal_time {
    /^[0-9]+$/: {}
    undef: {}
    default: {
      fail('lbstatus_recal_time must be a time in seconds (a number!)')
    }
  }
  case $wait_for_remove {
    /^[0-9]+$/: {}
    undef: {}
    default: {
      fail('wait_for_remove must be a time in seconds (a number!)')
    }
  }


  ## Global configuration
  apache::confd::file {'mod_cluster':
    confd          => $::apache::setup::mod::confd,
    content        => template('apache/mod/cluster.erb'),
    notify_service => $notify_service,
  }


  #######################################
  #       |              |
  # .    ,|---.,---.,---.|--- ,---.
  #  \  / |   ||   |`---.|    `---.
  #   `'  `   '`---'`---'`---'`---'
  #

  if $manager_vhost {
    ## Listen
    $manager_listen = $manager_ip ? {
      undef   => $manager_port,
      default => "${manager_ip}_${manager_port}",
    }

    $manager_vhost_name = $manager_vhost ? {
      true    => "${manager_servername}_${manager_port}",
      default => $manager_vhost,
    }

    if ! defined(Apache::Listen[$manager_listen]) {
      apache::listen {$manager_listen: }
    }

    if $manager_vhost and ( ! defined(Apache::Vhost[$manager_vhost_name])) {
      apache::vhost {$manager_vhost_name:
        servername     => $manager_servername,
        ip             => $manager_ip,
        port           => $manager_port,
        require        => Apache::Listen[$manager_listen],
        notify_service => $notify_service ,
      }
    }

    apache::vhost::mod::manager {$manager_vhost_name:
      vhost         => $manager_vhost_name,
      ip            => $manager_ip,
      port          => $manager_port,
      ## mod::manager specific configuration
      location       => $manager_location,
      allow_order    => $manager_allow_order,
      allow_from     => $manager_allow_from,
      deny_from      => $manager_deny_from,
      notify_service => $notify_service,
    }

  }
  if $advertise_vhost {
    ## Listen
    $advertise_listen = $advertise_ip ? {
      undef   => $advertise_port,
      default => "${advertise_ip}_${advertise_port}",
    }
    if ! defined(Apache::Listen[$advertise_listen]) {
      apache::listen {$advertise_listen: }
    }

    $advertise_vhost_name = $advertise_vhost ? {
      true    => "${advertise_servername}_${advertise_port}",
      default => $advertise_vhost,
    }

    if $advertise_vhost and (! defined(Apache::Vhost[$advertise_vhost_name])) {
      apache::vhost {$advertise_vhost_name:
        servername     => $advertise_servername,
        ip             => $advertise_ip,
        port           => $advertise_port,
        require        => Apache::Listen[$advertise_listen],
        notify_service => $notify_service,
      }
    }

    apache::vhost::mod::advertise {$advertise_vhost_name:
      vhost          => $advertise_vhost_name,
      ip             => $advertise_ip,
      port           => $advertise_port,
      ## mod::advertise specific configuration
      notify_service => $notify_service,
    }
  }

}
