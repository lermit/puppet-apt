# Class: apt::params
#
# This class defines default parameters used by the main module class apt
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to apt class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class apt::params {

  ### Unattended Upgrade related parameters
  $update_version = 'present'
  # Proceed each n-day
  $update_periodic_update = 1
  $update_periodic_download = 1
  $update_periodic_upgrade = 1
  $update_periodic_clean = 7
  $update_allowed_origins = [ 'stable',  '${distro_codename}-security' ]
  $update_package_blacklist = []
  $update_mail = ''
  $update_autoreboot = ''
  $update_bw_limit = ''
  $update_template = 'apt/02periodic.erb'
  $update_source = ''
  $update_upgrade_template = 'apt/50unattended-upgrades.erb'
  $update_upgrade_source = ''

  $update_package = $::operatingsystem ? {
    default => 'unattended-upgrades',
  }
  $update_config_file = $::operatingsystem ? {
    default => '/etc/apt/apt.conf.d/02periodic',
  }

  ### APT Proxying
  $proxy = ''
  $proxy_config_file = '/etc/apt/apt.conf.d/01proxy'
  $proxy_template = 'apt/01proxy.erb'
  $proxy_source = ''

  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'apt',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/apt/sources.list.d',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/apt/sources.list',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    default                   => '',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/apt',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/apt',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/apt/apt.log',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $version = 'present'
  $absent = false
  $update_present = false

  ### General module variables that can have a site or per module default
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
