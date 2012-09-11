# Define: apt::pin
#
# Add pinning information for specified package.
#
# Usage:
#  apt::pin { "name":
#    package  => 'package name',
#    release  => 'unstable',
#    priority => '50',
#  }
#
# This will create a configuration file into /etc/apt/preferences.d/${name}
# like that
#
#  Package: package name
#  Pin: release a=unstable
#  Pin-Priority: 50
#
#
define apt::pin (
  $package  = $name,
  $release  = 'stable',
  $priority = 100,
  $ensure   = present,
  $source   = false) {

  include apt

  # Create repository file
  file { "pinning-${name}":
      ensure  => $ensure,
      path    => "${apt::data_dir}/preferences.d/${name}",
      mode    => $apt::config_file_mode,
      owner   => $apt::config_file_owner,
      group   => $apt::config_file_group,
      require => File['apt.dir'],
      content => template('apt/pinning.erb'),
      notify  => Exec['apt_update'],
  }
}
