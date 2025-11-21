# Autosign Class.
#
# Implements the `autosign` gem to allow automated signing of certificates
#
# @summary Installs and configures the autosign gem.
#
# @example Declaring the class
#   class { autosign:
#     ensure   => 'latest',
#     settings => {
#       'general' => {
#         'loglevel' => 'INFO',
#       },
#       'jwt_token' => {
#         'secret'   => 'hunter2'
#         'validity' => '7200',
#       }
#     },
#   }
#
# @param package_name Name of the gem to install. Defaults to "autosign" and
#   there's probably no reason to override it.
#
# @param ensure Ensure parameter on the package to install. Set to "present",
#   "latest", "absent", or a specific gem version.
#
# @param puppetserver_ensure The ensure parameter for puppetserver gem
#
# @param gem_source Optional gem source
#
# @param configfile Path to the config file
#
# @param user User that should own the files, this should be user that the
#   Puppet server runs as.
#
# @param group Group that should own the config files
#
# @param journalpath Path to the journalfile, this will be managed as a
#   directory, with the journalfile placed under it.
#
# @param gem_provider Provide to use to the gem.
#
# @param manage_journalfile Weather or not to manage the journalfile
#
# @param manage_logfile Weather or not to manage the logfile
#
# @param manage_package Whether or not to manage the package
#
# @param config Hash of setting to use.

# @param log_level The log level to use.

# @param jwt_token_validity The validity of the JWT token in seconds.

# @param jwt_token_secret The secret to use for the JWT token.
#
class autosign (
  String               $ensure               = 'present',
  String               $package_name         = 'autosign',
  String               $puppetserver_ensure  = 'present',
  Boolean              $manage_journalfile   = true,
  Boolean              $manage_logfile       = true,
  Boolean              $manage_package       = true,
  Stdlib::Absolutepath $journalpath          = '/var/lib/autosign',
  Stdlib::Absolutepath $configfile           = '/etc/autosign.conf',
  Stdlib::Absolutepath $logpath              = '/var/log',
  String               $user                 = 'puppet',
  String               $group                = 'puppet',
  String               $gem_provider         = 'puppet_gem',
  Optional[String]     $gem_source           = undef,
  String               $log_level            = 'INFO',
  Integer              $jwt_token_validity   = 7200,
  Sensitive[String]     $jwt_token_secret    = Sensitive(fqdn_rand_string(30)),
  Variant[Sensitive[Hash], Hash] $config     = {},
) {
  # install the autosign gem
  if $autosign::manage_package {
    package { 'autosign via puppet_gem':
      ensure   => $autosign::ensure,
      name     => $autosign::package_name,
      source   => $autosign::gem_source,
      provider => $autosign::gem_provider,
    }
    package { 'autosign via puppetserver_gem':
      ensure   => $autosign::puppetserver_ensure,
      name     => $autosign::package_name,
      source   => $autosign::gem_source,
      provider => 'puppetserver_gem',
    }
  }

  $dir_ensure = $autosign::ensure ? {
    /(absent|purged)/ => 'absent',
    default           => 'directory',
  }

  $config_ensure = $autosign::ensure ? {
    /(absent|purged)/ => 'absent',
    default           => 'file',
  }

  # Merge the default config with the user-provided config, unwrap before merging 
  $settings             = Sensitive.new(deep_merge({
    'general'   => {
      'loglevel' => $autosign::log_level,
      'logfile'  => "${autosign::logpath}/autosign.log",
    },
    'jwt_token' => {
      'validity'    => $autosign::jwt_token_validity,
      'journalfile' => "${autosign::journalpath}/autosign.journal",
      # THIS IS NOT SECURE! It is marginally better than harcoding a password,
      # but it can be replicated externaly to the Puppet Master.
      # Please override this. It will also cause multi-master setups to not work
      # correctly, all the more reason to override it.
      'secret'      => $autosign::jwt_token_secret.unwrap,
    },
  }, $autosign::config.unwrap))

  $sensitive_config = Sensitive(epp('autosign/autosign.conf.epp', { settings => $settings.unwrap }))

  # Ensure we set the value to Sensitive so the secrets don't get revealed
  file { $autosign::configfile:
    ensure  => $config_ensure,
    mode    => '0640',
    content => $sensitive_config,
    owner   => $autosign::user,
    group   => $autosign::group,
  }

  if $autosign::manage_logfile {
    file { $settings.unwrap['general']['logfile']:
      ensure => 'file',
      mode   => '0640',
      owner  => $autosign::user,
      group  => $autosign::group,
    }
  }
  # the autosign key journal stores previously-used tokens to prevent re-use
  if $autosign::manage_journalfile {
    file { $autosign::journalpath:
      ensure => $dir_ensure,
      mode   => '0750',
      owner  => $autosign::user,
      group  => $autosign::group,
    }
    file { $settings.unwrap['jwt_token']['journalfile']:
      ensure  => 'file',
      mode    => '0640',
      owner   => $autosign::user,
      group   => $autosign::group,
      require => File[$autosign::journalpath],
    }
  }
}
