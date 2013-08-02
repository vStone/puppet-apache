# == Definition apache::loader
#
# Helper definition to load vhost entries from hiera.
# The provided name is used as hiera lookup key.
#
# === Parameters:
#
# [*type*]
#   Type of vhost definitions to create. Defaults to
#   apache::vhost.
#
# === Usage:
#
#   apache::loader{'apache_vhosts': }
#
#   apache::loader{'apache_ssl_vhosts':
#     type => 'apache::vhost::ssl',
#   }
#
define apache::loader(
  $type = 'apache::vhost',
) {

  $tree = hiera_hash($title, {})
  create_resources($type, $tree)

}
