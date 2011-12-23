# == Definition: apache::confd
#
# Helper class for conf.d style directories
#
# === Parameters:
#
#  $name:
#     Name of the confd style folder
#
#  $confd:
#     Subpath to use below the $apache::params::confd folder.
#
#  $order:
#     Order in the conf.d folder.
#
#  $load_content:
#     Extra content is added before the include statement.
#     The load file includes config files in the $confd.
#
#  $warn_content:
#     Extra ctontent to add to the warn file.
#     The warnfile is a README file in the $confd when $purge is enabled.
#     Make sure the content is commented out so mistakes with $includes do
#     not break the configuration.
#
#  $includes:
#     Pattern(s) to use when including files from the $confd.
#
#  $purge:
#     Purge all puppet 'foreign' files in the $confd.
#
# === Requires:
#
# === Sample Usage:
#
#   See apache::config::listen
#
define apache::confd (
  $confd,
  $order,
  $load_content,
  $warn_content,
  $includes,
  $purge,
  $use_config_root = false
) {

  require apache::params
  require apache::config

  # default confd to name.d
  $path_name = $confd? {
    undef   => "${name}.d",
    default => $confd
  }

  if $use_config_root == false {
    $name_d = "${apache::params::confd}/${path_name}"
    $include_root = "conf.d/${path_name}"
  } else {
    $name_d = "${apache::params::config_dir}/${path_name}"
    $include_root = $path_name
  }
  $name_dir_name = "apache-confd_${name}"

  # conf.d style folder with subconfigs.
  file {$name_dir_name:
    ensure  => directory,
    path    => $name_d,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    recurse => true,
    purge   => $purge,
    require => File[$apache::config::apache_confd],
  }

  $include_list = template('apache/confd/include.erb')

  $include = "## Apache::Confd['${name}']
${load_content}
${include_list}
"

  file {"apache-confd_${name}_load":
    ensure  => present,
    path    => "${apache::params::confd}/${order}_${name}.conf",
    content => $include,
    require => File[$name_dir_name]
  }

  if $purge {

    $warning = "## WARNING ##
# All files in this directory are managed by puppet.
# Unmanaged files will be PURGED!'
#
${warn_content}
"

    # warning that all files in this folder will be purged.
    file {"apache-confd_${name}_purge":
      ensure  => present,
      path    => "${name_d}/README",
      content => $warning,
      require => File[$name_dir_name]
    }
  }


}
