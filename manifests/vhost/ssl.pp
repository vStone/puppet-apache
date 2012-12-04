# == Class: apache::vhost::ssl
#
# Description of apache::vhost::ssl
#
# === Parameters:
#
# Most parameters are inherited from apache::vhost and will not be
# documented here.
#
# $ssl_cert::
#
# $ssl_key::
#
# $ssl_ciphersuite::
#
# $ssl_chain::
#
# $ssl_ca_path::
#
# $ssl_ca_file::
#
# $ssl_ca_crl_path::
#
# $ssl_ca_crl_file::
#
# $ssl_requestlog::   Logs non-error ssl requests to this file.
#                     This log includes the ssl protocol and cipher used.
#                     Filename is relative to the log_dir (apache::vhost).
#                     Defaults to '' (empty) which is disabled.
#
# $ssl_options::
#
# $ssl_verify_client::
#
# $ssl_verify_depth::
#
# === Actions:
#
# === Requires:
#
# === Sample Usage:
#
# === Todo:
#
# TODO: Update documentation
#
define apache::vhost::ssl (
  $ssl_cert,
  $ssl_key,
  $ssl_protocol      = 'all -SSLv2',
  $ssl_ciphersuite   = 'ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW',
  $ssl_chain         = undef,
  $ssl_ca_path       = undef,
  $ssl_ca_file       = undef,
  $ssl_ca_crl_path   = undef,
  $ssl_ca_crl_file   = undef,
  $ssl_requestlog    = undef,
  $ssl_requestlog_pattern = '%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b',
  $ssl_options       = undef,
  $ssl_verify_client = undef,
  $ssl_verify_depth  = undef,
  $servername        = undef,
  $serveraliases     = undef,
  $ensure            = 'present',
  $ip                = undef,
  $port              = undef,
  $admin             = undef,
  $vhostroot         = undef,
  $logdir            = undef,
  $accesslog         = undef,
  $errorlog          = undef,
  $placeholder_ssl   = undef,
  $errorlevel        = 'warn',
  $docroot           = undef,
  $docroot_purge     = false,
  $dirroot           = undef,
  $order             = '10',
  $vhost_config      = undef,
  $mods              = undef,
  $owner             = undef,
  $group             = undef,
  $logformat         = undef,
  $diroptions        = 'FollowSymlinks MultiViews'
) {

  require apache::mod::ssl

  ## Same logic as apache::vhost but we redo this since we need $server
  # and the default port is different.
  case $name {
    /^([a-z_]+[0-9a-z_\.-]*)_([0-9]+)$/: {
      $default_servername = $1
      $default_port = $2
    }
    default: {
      $default_servername = $name
      $default_port = '443'
    }
  }

  $vhost_port = $port ? {
    undef   => $default_port,
    default => $port,
  }

  $server = $servername ? {
    undef   => $default_servername,
    default => $servername,
  }

  $log_dir = $logdir ? {
    undef   => "${::apache::params::vhost_log_dir}/${server}",
    default => $logdir,
  }

  $ssl_content = template('apache/vhost/virtualhost_ssl.erb')

  # Replacing the ssl placeholder on the log formats.
  $placeholderssl = $placeholder_ssl ? {
    undef   => $::apache::params::placeholder_ssl,
    default => $placeholder_ssl,
  }

  $placeholders = {
    'ssl' => $placeholderssl,
  }

  $access_log = $accesslog ? {
    undef   => $::apache::params::default_accesslog,
    default => $accesslog,
  }
  $error_log = $errorlog ? {
    undef   => $::apache::params::default_errorlog,
    default => $errorlog,
  }

  apache::vhost{$title:
    ensure        => $ensure,
    name          => $name,
    servername    => $servername,
    serveraliases => $serveraliases,
    docroot       => $docroot,
    vhostroot     => $vhostroot,
    ip            => $ip,
    port          => $vhost_port,
    admin         => $admin,
    logdir        => $logdir,
    accesslog     => format_logfile($access_log, $placeholders),
    errorlog      => format_logfile($error_log, $placeholders),
    errorlevel    => $errorlevel,
    docroot_purge => $docroot_purge,
    dirroot       => $dirroot,
    order         => $order,
    mods          => $mods,
    owner         => $owner,
    group         => $group,
    logformat     => $logformat,
    vhost_config  => $ssl_content, # This is the only thing that is different.
    diroptions    => $diroptions,
  }
}

