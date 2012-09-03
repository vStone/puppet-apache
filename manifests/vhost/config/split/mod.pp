# = Definition: apache::vhost::config::split::mod
#
# This will place the configuration for this apache mod in a
# separate file that will be included (apache) by the main.
#
define apache::vhost::config::split::mod (
  $vhost,
  $ip       = undef,
  $port     = '80',
  $ensure   = 'present',
  $content  = '',
  $nodepend = false
) {


  ## Get the configured configuration style.
  require apache::vhost::config::split::params

  ## The path to a module configuration is configured by the config style.
  $modpath = $::apache::vhost::config::split::params::mod_path

  $modfile_path = "${::apache::setup::vhost::confd}/${modpath}"

  $filename = "${vhost}_mod_${name}.include"

  ## The apache::confd::file will make a file in a way
  # you have configured.
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
