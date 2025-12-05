# puppet-autosign module

[![Build Status](https://github.com/voxpupuli/puppet-autosign/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-autosign/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-autosign/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-autosign/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/autosign.svg)](https://forge.puppetlabs.com/puppet/autosign)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/autosign.svg)](https://forge.puppetlabs.com/puppet/autosign)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/autosign.svg)](https://forge.puppetlabs.com/puppet/autosign)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/autosign.svg)](https://forge.puppetlabs.com/puppet/autosign)
[![puppetmodule.info docs](https://www.puppetmodule.info/images/badge.svg)](https://www.puppetmodule.info/m/puppet-autosign)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-autosign.svg)](LICENSE)
[![Donated by Corey Osman & Daniel Dreier](https://img.shields.io/badge/donated%20by-Corey%20Osman%20&%20Daniel%20Dreier-fb7047.svg)](#transfer-notice)


## Switch to Vox Pupuli (PLEASE READ)
This module has recently moved to VoxPupuli and all further development will be handled by VoxPupuli contributors.  🎉

Prior to this handover the code was tagged to `v0.4.0` with some outstanding changes that were never released to the forge.  These additional changes are now tagged to `v0.5.0` with an associated branch of `v0.5.0-branch`.

- 👉 If you are dependent on the old forge module danieldrier-autosign use `v0.4.0`
- 👉 If you are dependedent on the `v0.4.0` but want the recent unreleased updates use `v0.5.0`.
- 👉 For the latest release of v0.5.0 with Post VoxPupuli integration use `v0.6.0`+
- 👉 A future major release will bring a small breaking change, and will likely be a `v1.0.0` release

## Overview

This module manages the [autosign gem](https://github.com/voxpupuli/autosign), which facilitates [policy-based certificate signing](https://docs.puppetlabs.com/puppet/latest/reference/ssl_autosign.html#policy-based-autosigning) in Puppet.

## Description

This module:

- installs and configures the [autosign gem](https://github.com/voxpupuli/autosign)
- provides a puppet function to generate JWT tokens for autosigning, for example when provisioning VMs using Puppet

## Setup

#### Install
```
puppet module install voxpupuli-autosign
```

### What autosign affects

  - Installs the autosign gem
  - Manages the autosign config file
    - `/etc/puppetlabs/puppetserver/autosign.conf` *Puppet Enterprise*
    - `/etc/autosign.conf` *Linux*
    - `/usr/local/etc/autosign.conf` *BSDs*
  - Creates journalfile and parent directory
    - `/opt/puppetlabs/server/autosign/autosign.journal` *Puppet Enterprise*
    - `/var/lib/autosign/autosign.journal` *Linux*
    - `/var/autosign/autosign.journal` *BSDs*
  - Manages logfile permissions
    - `/var/log/puppetlabs/puppetserver/autosign.log` *Puppet Enterprise*
    - `/var/log/autosign.log` *Linux*
    - `/var/log/autosign.log` *BSDs*

### Setup Requirements

This module does not configure puppet to do policy-based autosigning. See the [autosign gem](https://github.com/voxpupuli/autosign#2-configure-master) or [puppet docs](https://docs.puppetlabs.com/puppet/latest/reference/ssl_autosign.html#policy-based-autosigning) for instructions on how to configure policy-based autosigning. In puppet, the configuration will probably look something like:

```puppet
ini_setting {'policy-based autosigning':
  setting => 'autosign',
  path    => "${confdir}/puppet.conf",
  section => 'master',
  value   => '/opt/puppetlabs/puppet/bin/autosign-validator',
}
```

### Beginning with autosign

#### Install Module
```bash
puppet module install danieldreier-autosign (legacy)
puppet module install voxpupuli-autosign (New)
```

#### Basic manifest

A Basic configuration might look like the following. Do not use the default password!

```puppet
ini_setting { 'policy-based autosigning':
  setting => 'autosign',
  path    => "${::settings::confdir}/puppet.conf",
  section => 'master',
  value   => '/opt/puppetlabs/puppet/bin/autosign-validator',
  notify  => Service['pe-puppetserver'],
}

class { ::autosign:
  ensure => 'latest',
  config => {
    'general' => {
      'loglevel' => 'INFO',
    },
    'jwt_token' => {
      'secret'   => 'hunter2',
      'validity' => '7200',
    }
  },
}
```
**NOTE** You may also want to add a notify parameter as well to restart the puppetserver.
         `notify => Service['pe-puppetserver'] or notify => Service['puppetserver']`
## Usage

The `autosign::gen_autosign_token()` function allows you to generate temporary autosign
tokens in puppet. The syntax is:

```puppet
# return a one-time token that is only valid for the foo.example.com certname
# for the default validity as configured above.
autosign::gen_autosign_token('foo.example.com')

# return a one-time token that is only valid for foo.example.com for the
# next 3600 seconds.
autosign::gen_autosign_token('foo.example.com', 3600)

# return a one-time token that is valid for any certname matching the regex
# ^.*\.example\.com$ for the default validity period.
autosign::gen_autosign_token('/^.*\.example\.com$/')

# return a one-time token that is valid for any certname matching the regex
# ^.*\.example\.com$ for the next week (604800 seconds).
autosign::gen_autosign_token('/.*\.example\.com/', 604800)
```

Each of these will return a string which should be added to the
`csr_attributes.yaml` file by your puppet-based provisioning system. For
example, you might use an erb template to generate a cloudinit script that
creates the `csr_attributes.yaml` file.

Note that certnames in puppet do not necessarily correspond to hostnames, so
you should use regex matching to enforce certname policies rather than
attempting to restrict access to infrastructure by certname. A host named
`foo.example.com` can request a certificate for `bar.example.com` and the
master does not care.

### Generating tokens using tasks

This module comes with the `generate_token` task which uses the `autosign generate` command to generate new tokens. This task is designed to make integration with automated and manual provisioning methods easier for Puppet Enterprise users as humans or services can make a request for a token using their LDAP integrated user account instead of having to SSH in to the Puppet Master. Access to this task can be controlled via the Puppet Enterprise RBAC mechanism allowing for much easier control of user access.

Users wishing to generate tokens this way should run the task against the Puppet master and will receive the signing token as the result of the task. Running the `generate_token` task against any other node will fail.

## Classes

### `autosign`

#### Parameters

`package_name`: Name of the gem to install. Defaults to "autosign" and there's probably no reason to override it.

`ensure`: Ensure parameter on the package to install. Set to "present", "latest", "absent", or a specific gem version.

`configfile`: Path to the config file

`user`: User that should own the files, this should be user that the Puppet server runs as.

`group`: Group that should own the config files

`journalpath`: Path to the journalfile, this will be managed as a directory, with the journalfile placed under it.

`gem_provider`: Provide to use to the gem.

`manage_journalfile`: Weather or not to manage the journalfile

`manage_logfile`: Weather or not to manage the logfile

`config`: Hash of config to use.  This can optionally be a Sensitive type as well but you must wrap the entire hash in Sensitive.  `Sensitive.new({config goes here})`.  The config will by default always be
redacted even if not passing in Sensitive value.
## Development

Contributions are welcome. New functionality must have passing rspec test
coverage in the PR, and should ideally also have beaker test coverage for
major new functionality.

The primary development targets for this module are Puppet >= 4.x on Debian
Wheezy, CentOS 7, and FreeBSD 10. New functionality that requires updates to
`params.pp` should include relevant data for each of these platforms. If
you want support for other platforms, please include test coverage in the PR.

To contribute improvements, please fork this repository, create a feature
branch off your fork, and add the code there. Once your tests pass locally,
make a pull request and check that tests pass on CI, which probably tests a
wider range of puppet and ruby versions than you have locally.

# Transfer notice

In the past, the module was maintained by Daniel Dreier and Corey Osman.
The maintainers preferred that Vox Pupuli take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here.
