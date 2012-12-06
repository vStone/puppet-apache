# == Definition: apache::vhost
#
#  Define a apache vhost.
#
# === Parameters:
#
# $name::         The name is used for the filenames of various config files.
#                 It is a good idea to use <servername>_<port> so there is no
#                 overlapping of configuration files.
#
# $ensure::       Can be present/enabled/true or absent/disabled/false.
#
# $servername::   The server name to use.
#
# $serveraliases::  Can be a single server alias, an array of aliases or
#                   '' (empty) if no alias is needed.
#
# $ip::           The ip to use. Must match with a apache::namevhost.
#
# $port::         The port to use. Must match with apache::namevhost.
#                 Defaults to '80'
#
# $admin::        Admin email address.
#                 Defaults to apache::params::default_admin if defined,
#                 otherwise to admin@<servername>
#
# $vhostroot::    Root where all other files for this vhost will be placed.
#                 Defaults to the globally defined vhost root folder.
#
# $docroot::      Document root for this vhost.
#                 Defaults to /<vhostroot>/<servername>/<htdocs>
#
# $docroot_purge::  If you are going to manage the content of the docroot
#                   with puppet alone, you can safely enable purging here.
#                   This will also remove any file/dir that is not managed
#                   by puppet. Defaults to false.
#
# $dirroot::      Allow overrriding of the default Directory directive.
#                 Defaults to the docroot.
#
# $order::        Can be used to define the order for this vhost to be loaded.
#                 Defaults to 10.
#                 Special cases should have a lower or higher order value.
#
# $logdir::       Folder where log files are stored.
#                 Defaults to <global logdir>/<vhostname>
#
# $errorlevel::   Errorlevel to log on. See apache docs for more info.
#                 http://httpd.apache.org/docs/2.1/mod/core.html#loglevel
#                 Defaults to 'warn'.
#
# $accesslog::    Filename of the access log. Set to '' to disable logging.
#                 Defaults to whatever is configured in apache::params using
#                 the default_accesslog parameter.
#                 This can be a string with certain placeholders. See the
#                 _Log Placeholders_ section in the apache::params docs.
#
# $errorlog::     Filename of the error log. Set to '' to disable logging.
#                 Defaults to whatever is configured in apache::params using
#                 the default_errorlog parameter.
#                 This can be a string with certain placeholders. See the
#                 _Log Placeholders_ section in the apache::params docs.
#
# $vhost_config:: Custom virtualhost configuration.
#                 This does not override the complete config but is included
#                 within the <VirtualHost> directive after the document
#                 root definition and before including any apache vhost mods.
#
# $linklogdir::   Boolean. If enabled, a symlink to the apache logs is created
#                 in the root of the virtual host folder. Set false to disable.
#                 Defaults to true
#
# $diroptions::   String. defaults to "FollowSymlinks MultiViews"
#
# $mods::         An hash with vhost mods to be enabled.
#
# $logformat::    Logformat to use for accesslog.
#                 Defaults to 'combined'.
#
# === Usage / Best practice:
#
# Try and to use something unique for the name of each vhost defintion.
# You can use the same  port, ip and servername for different definitions,
# but the combination of all 3 always has to be unique!
#
#   class {'apache::params':
#     config_style ='simple',
#   }
#
#   include apache
#   apache::listen {'80': }
#   apache::namevhost {'80': }
#
#   apache::vhost {'myvhost.example.com':
#     ip   => '10.0.0.1',
#     port => '80',
#   }
#
# To enable modules together with the vhost, use following syntax:
#
#   apache::vhost {'myvhost.example.com':
#     mods => {
#       'reverse_proxy' => { proxypath => '/ http://localhost:8080' }
#     }
#   }
#
# If a module does not contain a classpath, we will prefix with
# +apache::vhost::mod::+. You can create custom modules outside the apache
# module this way. See the +apache::vhost::mod::dummy+ module on what parameters
# are required for a mod.
#
# === Todo:
#
# TODO: Add more examples.
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
