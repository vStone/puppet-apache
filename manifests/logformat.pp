# == Definition: apache::logformat
#
# Define custom logformats.
#
# === Parameters:
#
# $format::   The format you want to use. You do NOT need to escape double
#             double quotes. We will do that for you. If you have escaped
#             double quotes, we will not escape them again.
#
# $comment::  Additional content that gets added to the logformat definition.
#
# $name::     The name of the logformat, you can use this in your vhosts.
#
# === Example:
#
#   apache::listen { '10.0.0.1_80': }
#   apache::listen { '80': }
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
    confd          => $apache::setup::logformat::confd,
    content        => template('apache/confd/logformat.erb'),
    notify_service => $::apache::params::notify_service,
  }

}
