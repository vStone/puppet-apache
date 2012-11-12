# == Class: apache::security
#
# Various apache config settings to improve security.
#
#
class apache::security (
  $servertokens    = 'Prod',
  $serversignature = 'Off'
) {

  apache::augeas::set {'ServerTokens':
    value => $servertokens,
  }

  apache::augeas::set {'ServerSignature':
    value => $serversignature,
  }

  if $::osfamily {
    $family = inline_template('<%= scope.lookupvar("::osfamily").downcase %>')
  }
  else {
    $family = inline_template('<%= scope.lookupvar("::operatingsystem").downcase %>')
  }

  $hardened_class = "::apache::security::${family}"
  if defined($hardened_class) {
    include $hardened_class
  }

}
