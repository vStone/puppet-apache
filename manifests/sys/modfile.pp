# == Definition: apache::sys::modfile
#
# Modules use this type to add content to a virtualhost.
# The configuration type selected is responsible for making
# sure that the content is added to the virtualhost config.
#
# === Parameters:
#
# $vhost::        Name of the vhost definition this is for.
#
# $nodepend::     This flag has been added to prevent cyclic
#                 dependencies when the extra mods for a vhost
#                 are created by the vhost definition itself.
#                 This is the case when you provide mods using
#                 the mods parameter of apache::vhost.
#                 This parameter should be passed through by
#                 various mods when defining a modfile. For
#                 mods that you define in a separate type,
#                 this will default to false. In which case it
#                 will depend on the apache::vhost[$vhost]
#
# === Todo:
#
# TODO: Update documentation
#
define apache::sys::modfile (
  $vhost,
  $ip       = undef,
  $port     = '80',
  $ensure   = 'present',
  $content  = '',
  $nodepend = false,
  $order    = undef
) {

  $mod_def = "${::apache::params::config_base}::mod"
  $mod_args = {
    "${name}" => {
      'name'           => $name,
      'vhost'          => $vhost,
      'ip'             => $ip,
      'port'           => $port,
      'ensure'         => $ensure,
      'content'        => $content,
      'nodepend'       => $nodepend,
      'order'          => $order,
    }
  }

  create_resources($mod_def, $mod_args)

}
