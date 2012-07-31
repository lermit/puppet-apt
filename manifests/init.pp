# = Class: apt
#
# This is the main apt class
#
#
# == Parameters
#
# Specific class parameters
#
# [*proxy*]
#   If you want your client to use a APT proxy set this to the URL of
#   the APT Proxy (like 'http://apt-cache02.example.com:3142")
#
# [*proxy_config_file*]
#   File where configuration will be stored
#   (default /etc/apt/apt.conf.d/01proxy)
#
# [*proxy_template*]
#   If you want to overide defaut template set this one here
#
# [*proxy_source*]
#   Sets the content of source parameter for proxy configuration file
#   If defined, apt proxy config file will heve the param source => $source
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, apt class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $apt_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, apt main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $apt_source
#
# [*source_dir*]
#   If defined, the whole apt configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $apt_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $apt_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, apt main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $apt_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $apt_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $apt_absent
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $apt_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for apt checks
#   Can be defined also by the (top scope) variables $apt_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $apt_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $apt_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $apt_puppi_helper
#   and $puppi_helper
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $apt_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $apt_audit_only
#   and $audit_only
#
# Default class params - As defined in apt::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of apt package
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_file*]
#   Log file(s). Used by puppi
#
# [*update_present*]
#   True if you want auto update. Auto update is manage by unattended-update.
#
# [*update_version*]
#   Version of unattended-update you want.
#
# [*update_periodic_update*]
#   Do "apt-get update" automatically every n-days (0=disable)
#
# [*update_periodic_download*]
#   Do "apt-get upgrade --download-only" every n-days (0=disable)
#
# [*update_periodic_upgrade*]
#   Run the "unattended-upgrade" security upgrade script every n-days
#   (0=disabled)
#
# [*update_periodic_clean*]
#   Do "apt-get autoclean" every n-days (0=disable)
#
# [*update_allowed_origins*]
#   Allowed origins.
#
# [*update_package_blacklist*]
#   Package list to not auto upgrade
#
# [*update_mail*]
#   Email address to contact on auto upgrade
#
# [*update_remove_unused_dependencies*]
#   Do automatic removal of new unused dependencies after the upgrade
#   (equivalent to apt-get autoremove)
#
# [update_autoreboot*]
#   Automatically reboot *WITHOUT CONFIRMATION* if a
#   the file /var/run/reboot-required is found after the upgrade
#
# [*update_bw_limit*]
#   Use apt bandwidth limit feature.
#   Speed is in kb/sec
#
# [*update_template*]
#   Sets the path to the template to use as content for periodic update
#   configuration file. (/etc/apt/apt.conf.d/02periodic)
#   If defined, unattended upgrade main config file has:
#   content => content("$template")
#   Note update_source and update_template parameters are mutually exclusive:
#   don't use both
#   Can be defined also by the (top scope) variable $apt_update_template
#
# [*update_source*]
#   Sets the content of source parameter for periodic update configuration
#   file. (/etc/apt/apt.conf.d/02periodic)
#   If defined, unattended upgrade config file will have the param:
#   source => $source
#   Can be defined also by the (top scope) variable $apt_update_source
#
# [*update_upgrade_template*]
#   Sets the path to the template to use as content for unattended upgrade
#   configuration file. (/etc/apt/apt.conf.d/50unattended-upgrades)
#   If defined, unattended upgrade main config file has:
#   content => content("$template")
#   Note update_upgrade_source and update_upgrade_template parameters are
#   mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $apt_update_upgrade_template
#
# [*update_source*]
#   Sets the content of source parameter for unattended upgrade configuration
#   file. (/etc/apt/apt.conf.d/50unattended-upgrades)
#   If defined, unattended upgrade config file will have the param:
#   source => $source
#   Note update_upgrade_source and update_upgrade_template parameters are
#   mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $apt_update_upgrade_source
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include apt"
# - Call apt as a parametrized class
#
# See README for details.
#
#
# == Author
#   Romain THERRAT <romain42@gmail.com/>
#
class apt (
  $my_class                   = params_lookup( 'my_class' ),
  $source                     = params_lookup( 'source' ),
  $source_dir                 = params_lookup( 'source_dir' ),
  $source_dir_purge           = params_lookup( 'source_dir_purge' ),
  $template                   = params_lookup( 'template' ),
  $options                    = params_lookup( 'options' ),
  $version                    = params_lookup( 'version' ),
  $absent                     = params_lookup( 'absent' ),
  $monitor                  = params_lookup( 'monitor', 'global' ),
  $monitor_tool             = params_lookup( 'monitor_tool', 'global' ),
  $monitor_target           = params_lookup( 'monitor_target' ),
  $puppi                      = params_lookup( 'puppi' , 'global' ),
  $puppi_helper               = params_lookup( 'puppi_helper' , 'global' ),
  $debug                      = params_lookup( 'debug' , 'global' ),
  $audit_only                 = params_lookup( 'audit_only' , 'global' ),
  $package                    = params_lookup( 'package' ),
  $config_dir                 = params_lookup( 'config_dir' ),
  $config_file                = params_lookup( 'config_file' ),
  $config_file_mode           = params_lookup( 'config_file_mode' ),
  $config_file_owner          = params_lookup( 'config_file_owner' ),
  $config_file_group          = params_lookup( 'config_file_group' ),
  $config_file_init           = params_lookup( 'config_file_init' ),
  $data_dir                   = params_lookup( 'data_dir' ),
  $log_dir                    = params_lookup( 'log_dir' ),
  $log_file                   = params_lookup( 'log_file' ),
  $update_present             = params_lookup( 'update_present' ),
  $update_version             = params_lookup( 'update_version' ),
  $update_periodic_update     = params_lookup( 'update_periodic_update' ),
  $update_periodic_download   = params_lookup( 'update_periodic_download' ),
  $update_periodic_upgrade    = params_lookup( 'update_periodic_upgrade' ),
  $update_periodic_clean      = params_lookup( 'update_periodic_clean' ),
  $update_allowed_origins     = params_lookup( 'update_allowed_origins'),
  $update_package_blacklist   = params_lookup( 'update_package_blacklist'),
  $update_mail                = params_lookup( 'update_mail'),
  $update_autoreboot          = params_lookup( 'update_autoreboot'),
  $update_bw_limit            = params_lookup( 'update_bw_limit'),
  $update_template            = params_lookup( 'update_template' ),
  $update_source              = params_lookup( 'update_source' ),
  $update_config_file         = params_lookup( 'update_config_file' ),
  $update_upgrade_template    = params_lookup( 'update_upgrade_template'),
  $update_upgrade_source      = params_lookup( 'update_upgrade_source'),
  $update_upgrade_config_file = params_lookup( 'update_upgrade_config_file'),
  $proxy                      = params_lookup( 'proxy' ),
  $proxy_config_file          = params_lookup( 'proxy_config_file' ),
  $proxy_template             = params_lookup( 'proxy_template' ),
  $proxy_source               = params_lookup( 'proxy_source' ),
  ) inherits apt::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_update_present=any2bool($update_present)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)
  $bool_update_reboot=any2bool($update_autoreboot)

  ### Definition of some variables used in the module
  $manage_package = $apt::bool_absent ? {
    true  => 'absent',
    false => $apt::version,
  }

  $manage_file = $apt::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $apt::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $apt::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $apt::source ? {
    ''        => undef,
    default   => $apt::source,
  }

  if $apt::bool_absent == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  $manage_file_content = $apt::template ? {
    ''        => undef,
    default   => template($apt::template),
  }

  ### Unattended update
  $update_manage_package = $apt::bool_update_present ? {
    true  => $apt::update_version,
    false => 'absent',
  }

  $update_manage_file = $apt::bool_update_present ? {
    true  => 'present',
    false => 'absent',
  }

  $update_manage_file_source = $apt::update_source ? {
    ''      => undef,
    default => $apt::update_source,
  }

  $update_manage_file_content = $apt::update_template? {
    ''      => undef,
    default => template($apt::update_template),
  }

  $update_upgrade_manage_file_source = $apt::update_upgrade_source ? {
    ''      => undef,
    default => $apt::update_upgrade_source,
  }

  $update_upgrade_manage_file_content = $apt::update_upgrade_template ? {
    ''      => undef,
    default => template($apt::update_upgrade_template),
  }

  ### Proxy
  $proxy_manage_file = $apt::proxy ? {
    ''      => false,
    default => true,
  }

  $proxy_manage_file_source = $apt::proxy_source ? {
    ''      => undef,
    default => $apt::proxy_source,
  }

  $proxy_manage_file_content = $apt::proxy_template ? {
    ''      => undef,
    default => template($apt::proxy_template),
  }

  ### Managed resources
  package { 'apt':
    ensure => $apt::manage_package,
    name   => $apt::package,
  }

  package { 'apt-update':
    ensure => $apt::update_manage_package,
    name   => $apt::update_package,
  }

  exec { 'apt_update':
    command     => '/usr/bin/apt-get -qq update',
    logoutput   => false,
    refreshonly => true,
    subscribe   => [File[$apt::config_file], File[$apt::config_dir]],
  }

  file { 'apt.conf':
    ensure  => $apt::manage_file,
    path    => $apt::config_file,
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package['apt'],
    notify  => Exec['apt_update'],
    source  => $apt::manage_file_source,
    content => $apt::manage_file_content,
    replace => $apt::manage_file_replace,
    audit   => $apt::manage_audit,
  }

  file { 'apt-update.conf':
    ensure  => $apt::update_manage_file,
    path    => $apt::update_config_file,
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package['apt-update'],
    source  => $apt::update_manage_file_source,
    content => $apt::update_manage_file_content,
    replace => $apt::manage_file_replace,
    audit   => $apt::manage_audit,
  }

  file { 'apt-upgrade.conf':
    ensure  => $apt::update_manage_file,
    path    => $apt::update_upgrade_config_file,
    mode    => $apt::config_file_mode,
    owner   => $apt::config_file_owner,
    group   => $apt::config_file_group,
    require => Package['apt-update'],
    source  => $apt::update_upgrade_manage_file_source,
    content => $apt::update_upgrade_manage_file_content,
    replace => $apt::manage_file_replace,
    audit   => $apt::manage_audit,
  }

  if $apt::proxy_manage_file {
    file { 'apt-proxy.conf':
      ensure  => file,
      path    => $apt::proxy_config_file,
      mode    => $apt::config_file_mode,
      owner   => $apt::config_file_owner,
      group   => $apt::config_file_group,
      require => Package['apt'],
      source  => $apt::proxy_manage_file_source,
      content => $apt::proxy_manage_file_content,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  }

  # The whole apt configuration directory can be recursively overriden
  if $apt::source_dir {
    file { 'apt.dir':
      ensure  => directory,
      path    => $apt::config_dir,
      require => Package['apt'],
      notify  => Exec['apt_update'],
      source  => $apt::source_dir,
      recurse => true,
      purge   => $apt::source_dir_purge,
      replace => $apt::manage_file_replace,
      audit   => $apt::manage_audit,
    }
  } else {
    file { 'apt.dir':
      ensure  => directory,
      path    => $apt::config_dir,
      require => Package['apt'],
      audit   => $apt::manage_audit,
    }
  }


  ### Include custom class if $my_class is set
  if $apt::my_class {
    include $apt::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $apt::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'apt':
      ensure    => $apt::manage_file,
      variables => $classvars,
      helper    => $apt::puppi_helper,
    }
  }

  ### Service monitoring, if enabled ( monitor => true )
  if $apt::bool_monitor == true {
    monitor::apt { 'apt_update':
      tool     => $apt::monitor_tool,
      enable   => $apt::manage_monitor,
    }
  }

  ### Debugging, if enabled ( debug => true )
  if $apt::bool_debug == true {
    file { 'debug_apt':
      ensure  => $apt::manage_file,
      path    => "${settings::vardir}/debug-apt",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

}
