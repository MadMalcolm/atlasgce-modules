# cvmfs
## Description

The *cvmfs* module manages the [CernVM-FS](http://cernvm.cern.ch/portal/filesystem) configuration.

## Operating system support

Software package installation is only supported on RedHat based system but the configuration should work everywhere. _Note: On CernVM CernVM-FS is already configured and it is not recommended to use this module._

## Contents

The *cvmfs* module does the following:

* Installs the CernVM-FS package
* Creates the `cvmfs` user and group and necessary directories
* Clobbers `/etc/fuse.conf`
* Instantiates the *autofs* module with the `/cvmfs` mount point
* Writes the CernVM-FS configuration to `/etc/cvmfs/default.local`

## Variables and defaults

Here are some notable variables and their default values

<table>
  <tr><td><strong>Name</strong></td><td><strong>Description</strong></td><td><strong>Default</strong></td></tr>
  <tr><td><code>repositories</code></td><td>Comma separated list of CernVM-FS repositories</td><td><em>None</em></td></tr>
  <tr><td><code>squidproxy</code></td><td>Comma separated list of squid proxies</td><td><code>undef</code></td></tr>
  <tr><td><code>quota</code></td><td>Quota in MB</td><td><code>undef</code></td></tr>
  <tr><td><code>debug</code></td><td>Turn on debug logging</td><td><code>undef</code></td></tr>
</table>
