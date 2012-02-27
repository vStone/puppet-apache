# = Definition: apache::vhost::mod::passenger
#
# Enable a passenger configuration in this vhost.
#
# == Required Parameters:
#
# Your definition should always take the following parameters. When
# using the mods parameter from vhost, these get set automaticly.
#
# $ensure::     Disable or enable this mod. This will/should remove the config
#               file. Required for apache::vhost::modfile.
#
# $vhost::      Defined what vhost this module is for.
#               Required for apache::vhost::modfile
#
# $ip::         Required for apache::vhost::modfile.
#
# $port::       Required for apache::vhost::modfile.
#
# $docroot::    Document root.
#               Is automaticly filled in if pushed through apache::vhost.
#
# $automated::  This is a variable that is used under the hood.
#               If a mod is enabled directly through apache::vhost (no
#               specific apache::vhost::mod::* is defined) this is set
#               to true. Required for apache::vhost::modfile.
#
#
# == Optional Parameters:
#
#
# == Actions:
#
# Creates a apache::vhost::modfile for the vhost that has been selected.
#
# == Sample Usage:
#
# == Todo:
#
#  * Implement remaining parameters
#
define apache::vhost::mod::passenger (
  $vhost,
  $ip                   = undef,
  $port                 = '80',
  $ensure               = 'present',
  $docroot              = undef,
  $automated            = false,
  $app_root             = undef,
  $spawn_method         = undef,
  $global_queue         = undef,
  $passenger_enabled    = undef,
  $upload_buffer_dir    = undef,
  $restart_dir          = undef,
  $friendly_error_pages = undef,
  $buffer_response      = undef,
  $user                 = '',
  $group                = '',
  $min_instances        = undef,
  $max_requests         = undef,
  $stat_throttle_rate   = undef,
  $pre_start            = undef,
  $high_performance     = undef,
  $rails_autodetect     = undef,
  $rack_autodetect      = undef,
  $content              = ''
) {

  require apache::mod::passenger

  $passengerenabled =  $passenger_enabled ? {
    undef   => '',
    default => $passenger_enabled,
  }
  $uploadbufferdir =  $upload_buffer_dir ? {
    undef   => '',
    default => $upload_buffer_dir,
  }
  $friendlyerrorpages =  $friendly_error_pages ? {
    undef   => '',
    default => $friendly_error_pages,
  }
  $bufferresponse =  $buffer_response ? {
    undef   => '',
    default => $buffer_response,
  }
  $statthrottlerate = $stat_throttle_rate ? {
    undef   => '',
    default => $stat_throttle_rate,
  }
  $highperformance =  $high_performance ? {
    undef   => '',
    default => $high_performance,
  }
  $railsautodetect = $rails_autodetect ? {
    undef   => '',
    default =>  $rails_autodetect,
  }
  $rackautodetect = $rack_autodetect ? {
    undef   => '',
    default => $rack_autodetect,
  }

  $approot      = $app_root      ?{ undef => '', default => $app_root,     }
  $spawnmethod  = $spawn_method  ?{ undef => '', default => $spawn_method, }
  $globalqueue  = $global_queue  ?{ undef => '', default => $global_queue, }
  $restartdir   = $restart_dir   ?{ undef => '', default => $restart_dir,  }
  $mininstances = $min_instances ?{ undef => '', default => $min_instances,}
  $maxrequests  = $max_requests  ?{ undef => '', default => $max_requests, }
  $prestart     = $pre_start     ?{ undef => '', default => $pre_start,    }

  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/passenger.erb')

  apache::vhost::modfile {$title:
    ensure   => $ensure,
    vhost    => $vhost,
    ip       => $ip,
    port     => $port,
    nodepend => $automated,
    content  => $definition,
  }
}

