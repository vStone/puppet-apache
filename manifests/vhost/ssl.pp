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
# === Actions:
#
# === Requires:
#
# === Sample Usage:
#
define apache::vhost::ssl (
  $ssl_cert,
  $ssl_key,
  $ssl_ciphersuite  = 'ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL',
  $ssl_chain        = undef,
  $ssl_ca_path      = undef,
  $ssl_ca_file      = undef,
  $ssl_ca_crl_path  = undef,
  $ssl_ca_crl_file  = undef,
  $ssl_requestlog   = '',
  $servername       = undef,
  $serveraliases    = '',
  $ensure           = 'present',
  $ip               = undef,
  $port             = '443',
  $admin            = undef,
  $vhostroot        = undef,
  $logdir           = undef,
  $accesslog        = 'access.log',
  $errorlog         = 'error.log',
  $errorlevel       = 'warn',
  $docroot          = undef,
  $docroot_purge    = false,
  $order            = '10',
  $vhost_config     = '',
  $mods             = undef
) {


  $ssl_content = template('apache/vhost/virtualhost_ssl.erb')

  apache::vhost{$title:
    ensure        => $ensure,
    name          => $name,
    servername    => $servername,
    serveraliases => $serveraliases,
    docroot       => $docroot,
    vhostroot     => $vhostroot,
    ip            => $ip,
    port          => $port,
    admin         => $admin,
    logdir        => $logdir,
    accesslog     => $accesslog,
    errorlog      => $errorlog,
    errorlevel    => $errorlevel,
    docroot_purge => $docroot_purge,
    order         => $order,
    mods          => $mods,
    vhost_config  => $ssl_content, ## This is the only thing that differs really.
  }
}

