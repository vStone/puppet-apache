class apache {

  include apache::packages
  include apache::setup
  include apache::service

  Class['apache::packages'] -> Class['apache::setup'] -> Class['apache::service']

  case $puppetversion {
    /^2.7/:   {}
    default:  {
      require puppetlabs-create_resources
    }
  }

  $modulename = 'inuits-puppet-apache'
  $moduleversion = '0.1'

}
