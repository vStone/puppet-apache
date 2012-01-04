class apache {

  include apache::packages
  include apache::config
  include apache::service

  Class['apache::packages'] -> Class['apache::config'] -> Class['apache::service']

  case $puppetversion {
    /^2.7/:   {}
    default:  {
      require puppetlabs-create_resources
    }
  }

}
