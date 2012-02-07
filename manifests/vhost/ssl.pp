# == Class: apache::vhost::ssl
#
# Description of apache::vhost::ssl
#
# === Parameters:
#
# === Actions:
#
# === Requires:
#
# === Sample Usage:
#
define apache::vhost::ssl (
  $servername     = undef,
  $serveraliases  = '',
  $ensure         = 'present',
  $ip             = undef,
  $port           = '443',
  $admin          = undef,
  $vhostroot      = undef,
  $logdir         = undef,
  $errorlevel     = 'warn',
  $accesslog      = 'ssl_access.log',
  $errorlog       = 'ssl_error.log',
  $docroot        = undef,
  $docroot_purge  = false,
  $order          = '10',
  $vhost_config   = '',
  $mods           = undef,
  $ssl_cert,
  $ssl_key,
  $ssl_ciphersuite = 'ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL',
  $ssl_chain = undef,
  $ssl_ca_path = undef,
  $ssl_ca_file = undef,
  $ssl_ca_crl_path = undef,
  $ssl_ca_crl_file = undef
) {
  ## Copy paste snippets:
  # template("${module_name}/template.erb")
  # source => "puppet:///modules/${module_name}/file"

  ##@todo: Require ssl stuff to be present

  ##@todo: include vhost_config
  $ssl_content = ''

  apache::vhost{$title:
    ensure        => $ensure,
    name          => $name,
    servername    => $servername,
    serveraliases => $serveraliases,
    ip            => $ip,
    port          => $port,
    admin         => $admin,
    vhostroot     => $vhostroot,
    logdir        => $logdir,
    accesslog     => $accesslog,
    errorlog      => $errorlog,
    errorlevel    => $errorlevel,
    docroot       => $docroot,
    docroot_purge => $docroot_purge,
    order         => $order,
    mods          => $mods,
    vhost_config  => $ssl_content, ## This is the only thing that differs really.
  }

}

