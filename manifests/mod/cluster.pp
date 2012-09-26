# == Class: apache::mod::cluster
#
# Setup mod_cluster support
#
# == Parameters:
#
#
#
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
        fail ("The selected module ($mod_id) is not supported by this module.")
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

    package { $pkg_name:
      ensure  => installed,
      alias   => 'apache_mod_cluster',
      require => Package['apache'],
      notify  => Service['apache'],
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

  ## Global configuration
  apache::confd::file {'mod_cluster':
    confd   => $::apache::setup::mod::confd,
    content => template('apache/mod/cluster.erb'),
  }

}
