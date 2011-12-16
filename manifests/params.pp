class apache::params(
  $devel = 'no',
  $ssl = 'yes'
) {

  $package = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'apache2',
    /CentOS|RedHat/ => 'httpd',
    default         => 'httpd',
  }
  $package_devel = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'apache2-threaded-dev',
    /CentOS|RedHat/ => 'httpd-devel',
    /Archlinux/     => [],
    default         => [],
  }

  $package_ssl = $::operatingsystem ? {
    /Debian|Ubuntu/ => [],
    /CentOS|RedHat/ => 'mod_ssl',
    default         => [],
  }

  $service_name = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'apache2',
    /CentOS|RedHat/ => 'httpd',
    /Archlinux/     => 'httpd',
    default         => 'httpd',
  }

  $service_path = $::operatingsystem ? {
    /Archlinux/     => '/etc/rc.d/',
    default         => '/etc/init.d/',
  }

  $service_hasrestart = $::operatingsystem ? {
    default         => true,
  }

  $service_hasstatus = $::operatingsystem ? {
    default         => true,
  }

  $config_dir = $::operatingsystem ? {
    /Debian|Ubuntu/ => '/etc/apache2',
    /CentOS|RedHat/ => '/etc/httpd',
    default         => '/etc/httpd',
  }

  $config_path = $::operatingsystem ? {
    /Debian|Ubuntu/ => '/etc/apache2/apache2.conf',
    /CentOS|RedHat/ => '/etc/httpd/conf/httpd.conf',
    default         => '/etc/httpd/conf/httpd.conf',
  }

  $config_template = $::operatingsystem ? {
    /Archlinux/     => 'apache/archlinux-apache.conf.erb',
    /CentOS|RedHat/ => $::operatingsystemrelease ? {
      /^6/    => 'apache/centos6-apache.conf.erb',
      /^5/    => 'apache/centos-apache.conf.erb',
      default => 'apache/centos-apache.conf.erb',
    },
    /Debian|Ubuntu/ => 'apache/debian-apache.conf.erb',
    default         => 'apache/debian-apache.conf.erb',
  }

  $user = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'www-data',
    /CentOS|RedHat/ => 'apache',
    /Archlinux/     => 'http',
    default         => 'apache',
  }
  $group = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'www-data',
    /CentOS|RedHat/ => 'apache',
    /Archlinux/     => 'http',
    default         => 'apache',
  }

}
