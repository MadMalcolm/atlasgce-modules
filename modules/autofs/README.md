# autofs
## Description

The *autofs* module manages the [Autofs](http://www.autofs.org/) configuration for [CernVM-FS](http://cernvm.cern.ch/portal/filesystem).

## Operating system support

Software package installation is only supported on RedHat based system but the configuration should work everywhere. _Note: On CernVM Autofs is already configured and it is not recommended to use this module._

## Contents

The *autofs* module does the following:

* Installs the Autofs package
* Adds Autofs mounts to `/etc/auto.master`
* Starts the Autofs service

## Variables and defaults

Here are some notable variables and their default values

<table>
  <tr><td><strong>Name</strong></td><td><strong>Description</strong></td><td><strong>Default</strong></td></tr>
  <tr><td><code>mounts</code></td><td>A dictionary of mount point and configuration file pairs</td><td><code>undef</code></td></tr>
</table>
