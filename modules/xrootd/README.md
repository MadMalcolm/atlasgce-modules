# xrootd
## Description

The *xrootd* module manages the configuration and services for [XRootD](http://xrootd.slac.stanford.edu/).

## Operating system support

Software package installation is only supported on RedHat based system but the configuration should work everywhere.

## Contents

The *xrootd* module does the following:

* Installs the XRootD packages
* Creates the `xrootd` user and group and necessary directories
* Writes the system configuration to `/etc/sysconfig/xrootd`
* Writes the XRootD services configuration to `/etc/xrootd/xrootd.cfg`
* Writes the authentication configuration to `/etc/xrootd/auth_file`
* Starts the `xrootd` and `cmsd` services

If the machine role is `node` it also does the following:

* Creates the local cache directory
* Writes the stage-in script to `/etc/xrootd/stagein.sh`
* Starts the `frm_xfrd` and `frm_purged` services

## Variables and defaults

Here are some notable variables and their default values

<table>
  <tr><td><strong>Name</strong></td><td><strong>Description</strong></td><td><strong>Default</strong></td></tr>
  <tr><td><code>redirector</code></td><td>The address of the manager machine</td><td><em>None</em></td></tr>
  <tr><td><code>role</code></td><td>The role of this machine</td><td><em>None</em></td></tr>
  <tr><td><code>storage_path</code></td><td>XRootD storage path</td><td><code>/atlas</code></td></tr>
  <tr><td><code>oss_localroot</code></td><td>Local cache directory</td><td><code>/data/scratch</code></td></tr>
  <tr><td><code>global_redirector</code></td><td>Redirector for external requests</td><td><code>atlas-xrd-eu.cern.ch</code></td></tr>
  <tr><td><code>xrdport</code></td><td>Port for XRootD connections</td><td><code>1094</code></td></tr>
  <tr><td><code>debug</code></td><td>Turn on debug logging</td><td><code>undef</code></td></tr>
</table>
