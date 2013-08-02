# == Definition: apache::vhost
#
# Documentation for this definition can be found in the file vhost.README.md
# This is due to puppet bug [https://projects.puppetlabs.com/issues/11384](#11384)
#
define apache::vhost (
  $servername     = undef,
  $serveraliases  = undef,
  $ensure         = 'present',
  $ip             = undef,
  $port           = undef,
  $admin          = undef,
  $vhostroot      = undef,
  $logdir         = undef,
  $accesslog      = undef,
  $errorlog       = undef,
  $errorlevel     = 'warn',
  $docroot        = undef,
  $docroot_purge  = false,
  $dirroot        = undef,
  $order          = '10',
  $vhost_config   = undef,
  $mods           = undef,
  $linklogdir     = true,
  $diroptions     = undef,
  $owner          = undef,
  $group          = undef,
  $logformat      = undef,
  $timeout        = undef,
  $notify_service = undef
) {

  require apache::params
  require apache::setup::vhost

  ## This fixes undefined method function_always_array in the templates used.
  $_fix_always_array = always_array('')

  ## Fixes http://projects.puppetlabs.com/issues/3773
  $time_out = $timeout

  ####################################
  ####  Param checks & Defaults   ####
  ####################################

  # What the error message says...
  if $title == '' {
    fail('Can not create a vhost with empty title/name')
  }

  # Sanitize the ensure value and translate into an enable parameter.
  case $ensure {
    /enable|present/, true:   { $enable = true }
    /disable|absent/, false:  { $enable = false }
    default: {
      warning( template('apache/msg/vhost-ensure-unvalid-warning.erb') )
      $enable = true
    }
  }

  # Try to determine the servername and port from the name of the definition
  # if no servername and/or port have been explicitly set.
  case $name {
    /^([a-z_]+[0-9a-z_\.-]*)_([0-9]+)$/: {
      $default_servername = $1
      $default_port = $2
    }
    default: {
      $default_servername = $name
      $default_port = '80'
    }
  }

  # Use provided port or the default value.
  $vhost_port = $port ? {
    undef   => $default_port,
    default => $port,
  }

  # Use the provided servername or the default value.
  $server = $servername ? {
    undef   => $default_servername,
    default => $servername,
  }

  # Use the provided admin mail address or use the default value.
  $default_admin = $::apache::params::default_admin ? {
    undef   => "admin@${server}",
    default => $::apache::params::default_admin,
  }

  $serveradmin = $admin ? {
    undef   => $default_admin,
    default => $admin,
  }

  # Use the provided vhostroot or use the default value.
  $vhost_root = $vhostroot ? {
    undef   => "${::apache::params::vhost_root}/${server}",
    default =>  $vhostroot,
  }

  # Use the provided logdir or use the default value.
  $log_dir = $logdir ? {
    undef   => "${::apache::params::vhost_log_dir}/${name}",
    default => $logdir,
  }

  # When linklogdir is true, this is the location of the link we are creating
  # to the logdir.
  $log_link_target = "${vhost_root}/logs"

  # Use the provided docroot or use the default value.
  # This is used in the template in the DocumentRoot directive.
  $documentroot = $docroot ? {
    undef   => "${vhost_root}/${::apache::params::default_docroot}",
    default => $docroot,
  }

  # Use the provided dirroot or use the default value.
  # This is used in the template in the <Directory ...> directive.
  $directoryroot =  $dirroot ? {
    undef   => $documentroot,
    default => $dirroot,
  }

  $notifyservice = $notify_service ? {
    undef   => $::apache::params::notify_service,
    default => $notify_service,
  }

  ## Check for matching apache::namevhost
  # $log_ip::    Used in the placeholders for log filenames.
  # $ip_def::    Used in the template in the <Virtualhost ...> directive.
  # $listen::    Used for checking if an apache::namevhost definition exists.
  case $ip {
    undef: {
      $log_ip = 'all'
      $ip_def = '*'
      $listen = $vhost_port
    }
    default: {
      $log_ip = $ip
      $ip_def = $ip
      $listen = "${ip}_${vhost_port}"
    }
  }

  if ($ensure == 'present') and ( ! defined (Apache::Listen[$listen])) {
    warning( template('apache/msg/vhost-notdef-listen-warning.erb') )
  }

  # Use the provided diroptions, 'All' when diroptions is empty or the default.
  $dir_options = $diroptions ? {
    undef   => $::apache::params::diroptions,
    ''      => 'All',
    default => $diroptions,
  }

  # Use the provided logformat or use the default. This is the logformat for
  # the access log (combined, common, ...)
  $log_format = $logformat ? {
    undef   => $::apache::params::default_logformat,
    default => $logformat,
  }

  # Use provided accesslog or use the default if none is provided.
  $_access_log = $accesslog ? {
    undef   => $::apache::params::default_accesslog,
    default => $accesslog,
  }
  # Use provided errorlog or use the default if none is provided.
  $_error_log = $errorlog ? {
    undef   => $::apache::params::default_errorlog,
    default => $errorlog,
  }

  # Log (access- and errorlog) filename placeholders.
  $placeholders = {
    'servername' => $server,
    'name'       => $name,
    'port'       => $vhost_port,
    'listen'     => $listen,
    'ip'         => $log_ip,
    'ssl'        => '',           # Filter out %ssl placeholders.
  }

  # Replace placeholders in log filenames.
  $access_log = format_logfile($_access_log, $placeholders)
  $error_log = format_logfile($_error_log, $placeholders)

  ####################################
  ####   Create vhost structure   ####
  ####################################


  ## All files should be created before doing anything to the apache service
  Apache::Confd::File_exists {
    before  => Service['apache'],
  }
  File {
    before => Service['apache'],
  }

  apache::confd::file_exists {"apache-vhost-vhost-root-${name}":
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    path   => $vhost_root,
  }
  apache::confd::file_exists {"apache-vhost-vhost-docroot-${name}":
    ensure  => 'directory',
    owner   => $owner,
    group   => $group,
    path    => $documentroot,
    require => Apache::Confd::File_exists["apache-vhost-vhost-root-${name}"]
  }
  if $docroot_purge {
    Apache::Confd::File_exists["apache-vhost-vhost-docroot-${name}"] {
      purge => $docroot_purge
    }
  }
  apache::confd::file_exists {"apache-vhost-vhost-log-${name}":
    ensure  => 'directory',
    owner   => $owner,
    group   => $group,
    path    => $log_dir,
    require => File['apache-vhosts_log_root'],
  }

  if ( $linklogdir == true ) {
    apache::confd::file_exists { "apache-vhost-vhost-log-link-${name}":
      ensure  => 'link',
      target  => $log_dir,
      path    => $log_link_target,
      require => [
        Apache::Confd::File_exists["apache-vhost-vhost-log-${name}"],
        Apache::Confd::File_exists["apache-vhost-vhost-root-${name}"],
      ]
    }
  } else {
    apache::confd::file_exists { "apache-vhost-vhost-log-link-${name}":
      ensure  => 'absent',
      path    => $log_link_target,
    }
  }


  ####################################
  ####   Generate vhost config    ####
  ####################################
  # The location of the file is determined by the configurition type you
  # selected. We call the main class from that namespace to create the file.
  $style_def = "${::apache::params::config_base}::main"

  ## Note: puppet-lint warns on "${name}". Won't work properly without quotes.
  $style_args = {
    "${name}"          => {
      'ensure'         => $enable,
      'name'           => $name,
      'content'        => template('apache/vhost/virtualhost.erb'),
      'content_end'    => template('apache/vhost/virtualhost_end.erb'),
      'order'          => $order,
      'ip'             => $ip_def,
      'port'           => $vhost_port,
      'require'        => File[$documentroot],
      'notify_service' => $notifyservice,
    }
  }
  create_resources($style_def, $style_args)

  ## Create all the defined mods for this vhost.

  #:include: vhost.README.md
  $defaults = {
    'ensure'         => $ensure,
    'vhost'          => $name,
    'ip'             => $ip_def,
    'port'           => $vhost_port,
    'docroot'        => $documentroot,
    'notify_service' => $notifyservice,
    '_automated'     => true,
  }
  if $mods != undef and $mods != '' {
    ## Wraps arround create_resources to create the proper resource
    #  for each defined module in the hash.
    create_mods($name, $mods, $defaults)
  }

}
