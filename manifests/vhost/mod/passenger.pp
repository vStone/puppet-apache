# == Definition: apache::vhost::mod::passenger
#
# Enable a passenger configuration in this vhost.
#
# === Required Parameters:
#
# Some basic parameters that are always present in a module are not
# documented. See the apache::vhost::mod::dummy for an explanation on them.
#
# [*app_root*]
#
# [*spawn_method*]
#
# [*global_queue*]
#
# [*passenger_enabled*]
#
# [*upload_buffer_dir*]
#
# [*restart_dir*]
#
# [*friendly_error_pages*]
#
# [*buffer_response*]
#
# [*user*]
#
# [*group*]
#
# [*min_instances*]
#
# [*max_requests*]
#
# [*stat_throttle_rate*]
#
# [*pre_start*]
#
# [*high_performance*]
#
# [*rails_autodetect*]
#
# [*rails_baseuri*]
#
# [*rails_env*]
#
# [*rack_autodetect*]
#
# [*rack_baseuri*]
#
# [*rack_env*]
#
# === Sample Usage:
#
# === Todo:
#
# TODO: Implement remaining parameters
# TODO: Update documentation
#
define apache::vhost::mod::passenger (
  $vhost,
  $notify_service       = undef,
  $ensure               = 'present',
  $ip                   = undef,
  $port                 = '80',
  $docroot              = undef,
  $order                = undef,
  $_automated           = false,
  $_header              = false,
  $comment              = undef,
  $content              = undef,

  $app_root             = undef,
  $spawn_method         = undef,
  $global_queue         = undef,
  $passenger_enabled    = undef,
  $upload_buffer_dir    = undef,
  $restart_dir          = undef,
  $friendly_error_pages = undef,
  $buffer_response      = undef,
  $user                 = undef,
  $group                = undef,
  $min_instances        = undef,
  $max_requests         = undef,
  $stat_throttle_rate   = undef,
  $pre_start            = undef,
  $high_performance     = undef,
  $rails_autodetect     = undef,
  $rails_baseuri        = undef,
  $rails_env            = undef,
  $rack_autodetect      = undef,
  $rack_baseuri         = undef,
  $rack_env             = undef
) {

  require apache::mod::passenger

  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/passenger-3.erb')

  apache::sys::modfile {$title:
    ensure         => $ensure,
    vhost          => $vhost,
    ip             => $ip,
    port           => $port,
    nodepend       => $_automated,
    content        => $definition,
    order          => $order,
    notify_service => $notify_service,
  }
}

