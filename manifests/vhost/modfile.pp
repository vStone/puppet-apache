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
  $content  = '',
  $nodepend = false
) {


  ## Get the configured configuration style.
  $params_def = "${apache::params::config_base}::params"
  require $params_def

  ## The path to a module configuration is configured by the config style.
  $mtmp = inline_template('<%= scope.lookupvar("#{params_def}::mod_path") %>')
  $modpath = inline_template($mtmp)

  $modfile_path = "${apache::setup::vhost::confd}/$modpath"


  $filename = "${vhost}_mod_${name}.include"

  apache::confd::file { $filename:
    ensure          => $ensure,
    confd           => $modfile_path,
    content         => $content,
    use_config_root => $apache::setup::vhost::use_config_root,
  }
  if $nodepend == false {
    Apache::Confd::File[$filename] {
      require   => Apache::Vhost[$vhost],
      file_name => $filename,
    }
  }
  else {
    Apache::Confd::File[$filename] {
      file_name => "${name}.include",
    }
  }


}
