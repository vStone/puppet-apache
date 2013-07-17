# == Definition: apache::confd::file_exists
#
# Defines a file if, and only if, the file is not defined
# anywhere else.
#
# Uses the +path+  as name for the file resource. Also defaults the
# owner and group to what is defined in apache::params (daemon_user/group)
#
# For these kind of files, we do not notify the service my default since
# the resource that called this will probably do so on itself.
#
#
# If the file is a directory, and purge is not true, it will not replace symlinks.
#
define apache::confd::file_exists (
  $ensure,
  $path,
  $notify_service = false,
  $owner          = undef,
  $group          = undef,
  $purge          = false,
  $target         = undef
) {

  require apache::params

  $fowner = $owner ? {
    undef   => $::apache::params::daemon_user,
    default => $owner,
  }

  $fgroup = $group ? {
    undef   => $::apache::params::daemon_group,
    default => $group,
  }

  $_path = regsubst($path, '/$', '')

  if defined(File[$_path]) {
    info("The folder ${_path} is already defined. Skipping creation.")
  }
  else {
    file {$_path:
      ensure => $ensure,
      owner  => $fowner,
      group  => $fgroup,
      purge  => $purge,
      target => $target,
    }
    if $ensure == 'directory' and $purge == false {
      File[$_path] {
        replace => false,
      }
    }

    if $notify_service {
      File[$_path] {
        notify => Service['apache'],
      }
    }
  }


}
