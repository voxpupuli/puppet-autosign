# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v0.6.0](https://github.com/voxpupuli/puppet-autosign/tree/v0.6.0) (2025-12-04)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/v0.5.0...v0.6.0)

**Merged pull requests:**

- Update Readme, prep for v0.6.0 [\#49](https://github.com/voxpupuli/puppet-autosign/pull/49) ([logicminds](https://github.com/logicminds))
- initial modulesync [\#47](https://github.com/voxpupuli/puppet-autosign/pull/47) ([logicminds](https://github.com/logicminds))
- Remove pdk sync file [\#46](https://github.com/voxpupuli/puppet-autosign/pull/46) ([logicminds](https://github.com/logicminds))
- Numerous updates [\#43](https://github.com/voxpupuli/puppet-autosign/pull/43) ([treydock](https://github.com/treydock))
- Use facts hash to avoid undefined variable errors [\#42](https://github.com/voxpupuli/puppet-autosign/pull/42) ([treydock](https://github.com/treydock))

## [v0.5.0](https://github.com/voxpupuli/puppet-autosign/tree/v0.5.0) (2025-11-20)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/v0.4.0...v0.5.0)

**Closed issues:**

- log file should not be world-readable [\#1](https://github.com/voxpupuli/puppet-autosign/issues/1)

## [v0.4.0](https://github.com/voxpupuli/puppet-autosign/tree/v0.4.0) (2020-05-14)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/v0.3.0...v0.4.0)

**Fixed bugs:**

- Unspecified dependency on inifile [\#23](https://github.com/voxpupuli/puppet-autosign/issues/23)

**Closed issues:**

- Please tag a new release [\#35](https://github.com/voxpupuli/puppet-autosign/issues/35)
- forge module bump [\#34](https://github.com/voxpupuli/puppet-autosign/issues/34)
- Line 77 of the README.md missing a "," [\#32](https://github.com/voxpupuli/puppet-autosign/issues/32)
- ${confdir} is not valid in Readme example [\#17](https://github.com/voxpupuli/puppet-autosign/issues/17)
- puppet path wrong in documentation [\#11](https://github.com/voxpupuli/puppet-autosign/issues/11)
- use puppetserver\_gem when installing on JVM puppetserver [\#2](https://github.com/voxpupuli/puppet-autosign/issues/2)

**Merged pull requests:**

- Fixes \#2 - use puppetserver\_gem when installing on JVM puppetserver [\#40](https://github.com/voxpupuli/puppet-autosign/pull/40) ([logicminds](https://github.com/logicminds))
- Add puppet 4 function [\#39](https://github.com/voxpupuli/puppet-autosign/pull/39) ([logicminds](https://github.com/logicminds))
- Run pdk update [\#38](https://github.com/voxpupuli/puppet-autosign/pull/38) ([logicminds](https://github.com/logicminds))
- Add GitHub Action to publish to Forge [\#37](https://github.com/voxpupuli/puppet-autosign/pull/37) ([danieldreier](https://github.com/danieldreier))

## [v0.3.0](https://github.com/voxpupuli/puppet-autosign/tree/v0.3.0) (2020-05-11)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/v0.2.0...v0.3.0)

**Closed issues:**

- does not work on puppet 6.13.0 [\#33](https://github.com/voxpupuli/puppet-autosign/issues/33)
- Invalid pattern found in /opt/puppetlabs/puppet/bin/autosign-validator [\#27](https://github.com/voxpupuli/puppet-autosign/issues/27)
- Module doesn't install the autosign gem: [\#26](https://github.com/voxpupuli/puppet-autosign/issues/26)

**Merged pull requests:**

- Sensitive type [\#36](https://github.com/voxpupuli/puppet-autosign/pull/36) ([logicminds](https://github.com/logicminds))
- Provide a mechanism that allows the package to be un-managed [\#29](https://github.com/voxpupuli/puppet-autosign/pull/29) ([rjpearce](https://github.com/rjpearce))
- Update metadata versions [\#28](https://github.com/voxpupuli/puppet-autosign/pull/28) ([pillarsdotnet](https://github.com/pillarsdotnet))
- 0.2.1: Don't fail on Puppet 7 and beyond [\#25](https://github.com/voxpupuli/puppet-autosign/pull/25) ([danielparks](https://github.com/danielparks))
- Support Puppet 6 [\#24](https://github.com/voxpupuli/puppet-autosign/pull/24) ([danielparks](https://github.com/danielparks))
- Fix spelling and improve the 'validfor' description in the Task [\#22](https://github.com/voxpupuli/puppet-autosign/pull/22) ([natemccurdy](https://github.com/natemccurdy))

## [v0.2.0](https://github.com/voxpupuli/puppet-autosign/tree/v0.2.0) (2018-01-17)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/v0.1.5...v0.2.0)

**Merged pull requests:**

- Add autosign task [\#21](https://github.com/voxpupuli/puppet-autosign/pull/21) ([dylanratcliffe](https://github.com/dylanratcliffe))

## [v0.1.5](https://github.com/voxpupuli/puppet-autosign/tree/v0.1.5) (2017-10-23)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/v0.1.2...v0.1.5)

**Merged pull requests:**

- 0.1.5: Use contain [\#19](https://github.com/voxpupuli/puppet-autosign/pull/19) ([danielparks](https://github.com/danielparks))
- Switched to using contain [\#18](https://github.com/voxpupuli/puppet-autosign/pull/18) ([genebean](https://github.com/genebean))
- 0.1.4: Formally support Puppet 5 [\#15](https://github.com/voxpupuli/puppet-autosign/pull/15) ([danielparks](https://github.com/danielparks))
- make Puppet version regex work for Puppet 5 too [\#14](https://github.com/voxpupuli/puppet-autosign/pull/14) ([richburroughs](https://github.com/richburroughs))
- Made regex able to handle multiple digits [\#13](https://github.com/voxpupuli/puppet-autosign/pull/13) ([genebean](https://github.com/genebean))
- CI Update [\#9](https://github.com/voxpupuli/puppet-autosign/pull/9) ([willtome](https://github.com/willtome))
- Allow override of gem\_provider [\#6](https://github.com/voxpupuli/puppet-autosign/pull/6) ([prozach](https://github.com/prozach))
- Fix example syntax in README [\#5](https://github.com/voxpupuli/puppet-autosign/pull/5) ([zachfi](https://github.com/zachfi))

## [v0.1.2](https://github.com/voxpupuli/puppet-autosign/tree/v0.1.2) (2015-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/v0.1.1...v0.1.2)

## [v0.1.1](https://github.com/voxpupuli/puppet-autosign/tree/v0.1.1) (2015-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/v0.1.0...v0.1.1)

## [v0.1.0](https://github.com/voxpupuli/puppet-autosign/tree/v0.1.0) (2015-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-autosign/compare/c09fb37de2b81b0974fcfc47645d2116ba03c0b3...v0.1.0)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
