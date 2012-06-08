# = Class: apt
#
# This is the main apt class
#
#
# == Parameters
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
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $puppi               = params_lookup( 'puppi' , 'global' ),
  $puppi_helper        = params_lookup( 'puppi_helper' , 'global' ),
  $debug               = params_lookup( 'debug' , 'global' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $package             = params_lookup( 'package' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $config_file_init    = params_lookup( 'config_file_init' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $log_dir             = params_lookup( 'log_dir' ),
  $log_file            = params_lookup( 'log_file' )
  ) inherits apt::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_puppi=any2bool($puppi)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

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

  $manage_file_content = $apt::template ? {
    ''        => undef,
    default   => template($apt::template),
  }

  ### Managed resources
  package { 'apt':
    ensure => $apt::manage_package,
    name   => $apt::package,
  }

  exec { 'apt_update':
    command     => "/usr/bin/apt-get -qq update",
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
