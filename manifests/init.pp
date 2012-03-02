class apache {

  include apache::module
  include apache::packages
  include apache::setup
  include apache::service

  Class['apache::packages'] -> Class['apache::setup'] -> Class['apache::service']

  case $::puppetversion {
    /^2.7/:   {}
    default:  {
      require puppetlabs-create_resources
    }
  }

}
