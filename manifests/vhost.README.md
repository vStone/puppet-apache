== Definition: apache::vhost

 Define a apache vhost.

=== Parameters:

  $name::         The name is used for the filenames of various config files.
                  It is a good idea to use <servername>_<port> so there is no
                  overlapping of configuration files.
 
  $ensure::       Can be present/enabled/true or absent/disabled/false.
 
  $servername::   The server name to use.
 
  $serveraliases::  Can be a single server alias, an array of aliases or
                    '' (empty) if no alias is needed.
 
  $ip::           The ip to use. Must match with a apache::namevhost.
 
  $port::         The port to use. Must match with apache::namevhost.
                  Defaults to '80'
 
  $admin::        Admin email address.
                  Defaults to apache::params::default_admin if defined,
                  otherwise to admin@<servername>
 
  $vhostroot::    Root where all other files for this vhost will be placed.
                  Defaults to the globally defined vhost root folder.
 
  $docroot::      Document root for this vhost.
                  Defaults to /<vhostroot>/<servername>/<htdocs>
 
  $docroot_purge::  If you are going to manage the content of the docroot
                    with puppet alone, you can safely enable purging here.
                    This will also remove any file/dir that is not managed
                    by puppet. Defaults to false.
 
  $dirroot::      Allow overrriding of the default Directory directive.
                  Defaults to the docroot.
 
  $order::        Can be used to define the order for this vhost to be loaded.
                  Defaults to 10.
                  Special cases should have a lower or higher order value.
 
  $logdir::       Folder where log files are stored.
                  Defaults to <global logdir>/<vhostname>
 
  $errorlevel::   Errorlevel to log on. See apache docs for more info.
                  http://httpd.apache.org/docs/2.1/mod/core.html#loglevel
                  Defaults to 'warn'.
 
  $accesslog::    Filename of the access log. Set to '' to disable logging.
                  Defaults to whatever is configured in apache::params using
                  the default_accesslog parameter.
                  This can be a string with certain placeholders. See the
                  _Log Placeholders_ section in the apache::params docs.
 
  $errorlog::     Filename of the error log. Set to '' to disable logging.
                  Defaults to whatever is configured in apache::params using
                  the default_errorlog parameter.
                  This can be a string with certain placeholders. See the
                  _Log Placeholders_ section in the apache::params docs.
 
  $vhost_config:: Custom virtualhost configuration.
                  This does not override the complete config but is included
                  within the <VirtualHost> directive after the document
                  root definition and before including any apache vhost mods.
 
  $linklogdir::   Boolean. If enabled, a symlink to the apache logs is created
                  in the root of the virtual host folder. Set false to disable.
                  Defaults to true
 
  $diroptions::   String. defaults to "FollowSymlinks MultiViews"
 
  $mods::         An hash with vhost mods to be enabled.
 
  $logformat::    Logformat to use for accesslog.
                  Defaults to 'combined'.
 
=== Usage / Best practice:
 
  Try and to use something unique for the name of each vhost defintion.
  You can use the same  port, ip and servername for different definitions,
  but the combination of all 3 always has to be unique!
 
    class {'apache::params':
      config_style ='simple',
    }
 
    include apache
    apache::listen {'80': }
    apache::namevhost {'80': }
 
    apache::vhost {'myvhost.example.com':
      ip   => '10.0.0.1',
      port => '80',
    }
 
  To enable modules together with the vhost, use following syntax:
 
    apache::vhost {'myvhost.example.com':
      mods => {
        'reverse_proxy' => { proxypath => '/ http://localhost:8080' }
      }
    }
 
  If a certain module needs to be defined multiple times, use an array.
 
    apache::vhost {'myvhost.example.com':
      mods => {
        'rewrite' => [
          { rewrite_cond => 'foo', rewrite_rule  => 'bar', },
          { rewrite_cond => 'fooo', rewrite_rule => 'baaar', },
        ],
      }
    }
 
 
  If a module does not contain a classpath, we will prefix with
  +apache::vhost::mod::+. You can create custom modules outside the apache
  module this way. See the +apache::vhost::mod::dummy+ module on what parameters
  are required for a mod.
 
=== Todo:
 
  TODO: Add more examples.
 
