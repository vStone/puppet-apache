# == Definition: apache::vhost::modfile
#
#   Helper file wrapper for extra mods for a certain vhost.
#
# === Parameters:
#
# $vhost:
#
# $ensure:
#
#
define apache::vhost::modfile (
  $vhost,
  $ip       = undef,
  $port     = '80',
  $ensure   = 'present',
  $content  = ''
) {

  $filename = "${vhost}_mod_${name}.include"

  ## Get the configured configuration style.
  $params_def = "${apache::params::config_base}::params"
  require $params_def

  ## The path to a module configuration is configured by the config style.
  $modpath_template = inline_template('<%= scope.lookupvar("#{params_def}::mod_path") %>')
  $modpath = inline_template($modpath_template)

  $modfile_path = "${apache::setup::vhost::confd}/$modpath"

  apache::confd::file { $filename:
    confd           => $modfile_path,
    file_name       => $filename,
    content         => $content,
    use_config_root => $apache::setup::vhost::use_config_root,
    require         => Apache::Vhost[$vhost],
  }


}
