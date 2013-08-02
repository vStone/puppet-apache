# == Definition: apache::logformat
#
# Define custom logformats.
#
# === Parameters:
#
# [*name*]
#   The name of the logformat, you can use this in your vhosts.
#
# [*format*]
#   The format you want to use. You do NOT need to escape double
#   double quotes. We will do that for you. If you have escaped
#   double quotes, we will not escape them again.
#
# [*comment*]
#   Additional content that gets added to the logformat definition.
#
# === Example:
#
#   apache::logformat { 'custom':
#     format => '%v %h %l %u %t "%r" %>'s %b
#   }
#
# See the apache documentation for more information on the placeholders
# you can use: http://httpd.apache.org/docs/current/mod/mod_log_config.html
#
define apache::logformat (
  $format,
  $comment = ''
) {

  ## Requirements
  require apache::params
  require apache::setup::logformat

  ####################################
  ####       Prepare content      ####
  ####################################

  $fname = "logformat_${name}"

  $_format = $format

  apache::confd::file {$fname:
    confd          => $::apache::setup::logformat::confd,
    content        => template('apache/confd/logformat.erb'),
    notify_service => $::apache::params::notify_service,
  }

}
