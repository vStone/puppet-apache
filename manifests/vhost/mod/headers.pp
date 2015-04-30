# == Definition: apache::vhost::mod::headers
#
# Use Header and/or RequestHeader
#
# === Required Parameters:
#
# Some basic parameters that are always present in a module are not
# documented. See the apache::vhost::mod::dummy for an explanation on them.
#
# [*header*]
#   Array or single header rule.
#
# [*requestheader*]
#   Array or single request header rule.
#
# === Todo:
#
# TODO: Update documentation
#
define apache::vhost::mod::headers (
  $vhost,
  $notify_service = undef,
  $ensure         = 'present',
  $ip             = undef,
  $port           = '80',
  $docroot        = undef,
  $order          = undef,
  $_automated     = false,
  $_header        = true,

  $comment        = undef,
  $header         = [],
  $requestheader  = []
) {

  require apache::mod::headers

  ## Generate the content for your module file:
  $definition = template('apache/vhost/mod/headers.erb')

  apache::sys::modfile {$title:
    ensure         => $ensure,
    vhost          => $vhost,
    ip             => $ip,
    port           => $port,
    nodepend       => $_automated,
    content        => $definition,
    order          => $order,
    notify_service => $notify_service,
  }
}

