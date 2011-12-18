# Class: apache::confd
#
# Helper class for conf.d style directories
#
# Parameters:
#  $name:
#     Name of the confd style folder
#
#  $subpath:
#     Subpath to use below the $apache::params::confd folder.
#     Defaults to "${name}.d"
#
#  $order:
#     Order in the conf.d folder.
#
#  $load_content:
#     Extra content is added before the include statement.
#     The load file includes config files in the $subpath.
#
#  $warn_content:
#     Extra ctontent to add to the warn file.
#     The warnfile is a README file in the $subpath when $purge is enabled.
#     Make sure the content is commented out so mistakes with $includes do
#     not break the configuration.
#
#  $includes:
#     Pattern to use when including files from the $subpath.
#     Defaults to '*.conf'
#
#  $purge:
#     Purge all puppet 'foreign' files in the $subpath.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   See apache::listen
#
define apache::confd (
  $subpath      = undef,
  $order        = '05',
  $load_content = '# (add contnet using the load_content parameter)',
  $warn_content = '# (add content using the warn_content parameter)',
  $includes     = '*.conf',
  $purge        = true
) {

  require apache::params
  require apache::config

  # default subpath to name.d
  $path_name = $subpath ? {
    undef   => "${name}.d",
    default => $subpath
  }

  $name_d = "${apache::params::confd}/${path_name}"
  $name_dir_name = "apache-confd_${name}"

  # conf.d style folder with subconfigs.
  file {$name_dir_name:
    ensure  => directory,
    path    => "${name_d}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    recurse => true,
    purge   => $purge,
    require => File[$apache::config::apache_confd],
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

  $include = "## Apache::Confd['${name}']
${load_content}
Include conf.d/${path_name}/${includes}
"

  file {"apache-confd_${name}_load":
    ensure  => present,
    path    => "${apache::params::confd}/${order}_${name}.conf",
    content => $include,
    require => File[$name_dir_name]
  }

}
