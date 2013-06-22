define apache::augeas (
  $value          = undef,
  $ensure         = 'present',
  $notify_service = undef,
  $config         = undef,
) {

  case $ensure {
    true, 'present', 'default': {
      apache::augeas::set {$name:
        value          => $value,
        config         => $config,
        notify_service => $notify_service,
      }
    }
    false, 'absent': {
      apache::augeas::rm {$name:
        value          => $value,
        config         => $config,
        notify_service => $notify_service
      }
    }
  }

}
