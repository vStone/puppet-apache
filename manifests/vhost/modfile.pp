# = Definition: apache::vhost::modfile
#
# Modules use this type to add content to a virtualhost.
# The configuration type selected is responsible for making
# sure that the content is added to the virtualhost config.
#
# == Todo:
#
# TODO: Update documentation
#
define apache::vhost::modfile (
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
    "${name}"    => {
      'name'     => $name,
      'vhost'    => $vhost,
      'ip'       => $ip,
      'port'     => $port,
      'ensure'   => $ensure,
      'content'  => $content,
      'nodepend' => $nodepend,
      'order'    => $order
    }
  }

  create_resources($mod_def, $mod_args)

}
