# == Definition: apache::sys::config::split::mod
#
# This will place the configuration for this apache mod in a
# separate file that will be included (apache) by the main.
#
# === Todo:
#
# TODO: Update documentation
#
define apache::sys::config::split::mod (
  $vhost,
  $ip       = undef,
  $port     = '80',
  $ensure   = 'present',
  $content  = '',
  $nodepend = false,
  $order    = undef
) {


  ## Get the configured configuration style.
  require apache::sys::config::split::params

  ## The path to a module configuration is configured by the config style.
  $modpath = $::apache::sys::config::split::params::mod_path

  $modfile_path = "${::apache::setup::vhost::confd}/${modpath}"

  $order_ = $order ? {
    undef   => '',
    default => sprintf('%04d_', $order),
  }

  $shortname = regsubst($name, "^${vhost}_(.*)", '\1')
  $filename = "${vhost}_mod_${order_}${shortname}.include"

  ## Add the header to the content for every file
  $with_header = template('apache/vhost/config/splitconfig_mod_content.erb')

  ## The apache::confd::file will make a file in a way
  # you have configured.
  apache::confd::file { $filename:
    ensure          => $ensure,
    confd           => $modfile_path,
    content         => $with_header,
    use_config_root => $apache::setup::vhost::use_config_root,
    file_name       => $filename,
  }
  if $nodepend == false {
    Apache::Confd::File[$filename] {
      require   => Apache::Vhost[$vhost],
    }
  }


}
