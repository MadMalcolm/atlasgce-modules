# condor
## Description

The *condor* module manages the configuration and services for [Condor](http://research.cs.wisc.edu/htcondor/).

## Operating system support

Software package installation is only supported on RedHat based system but the configuration should work everywhere.

## Condor roles

The *condor* module supports the following roles, all of which have their own `condor_config.local`. _Note: The `collector` and the `submit` Condor roles have not been extensively tested, and have currently no matching machine roles_

<table>
  <tr><td><code>head</code></td><td>Condor manager</td><td>collector, negotiator, schedd</td></tr>
  <tr><td><code>node</code></td><td>Condor worker</td><td>startd</td></tr>
  <tr><td><code>csnode</code></td><td>Condor worker for Cloud Scheduler</td><td>startd</td></tr>
  <tr><td><code>collector</code></td><td>Condor manager with multiple collectors</td><td>collector &#215; N, negotiator, schedd</td></tr>
  <tr><td><code>submit</code></td><td>Condor submit node</td><td>schedd</td></tr>
</table>

## Contents

The *condor* module does the following:

* Installs the Condor package
* Creates the `condor` user and group and necessary directories
* Creates Condor job execution users (`node` and `csnode` roles)
* Creates the Condor pool password (Optional)
* Writes role specific configuration to `/etc/condor/condor_config.local`
* Writes job wrapper script to `/usr/libexec/condor/jobwrapper.sh` (or `/opt/condor/libexec/jobwrapper.sh` for CernVM)
* Writes a custom service control script to `/etc/init.d/condor` (`csnode` role)
* Starts the Condor service (all roles except `csnode`)

## Variables and defaults

Here are some notable variables and their default values

<table>
  <tr><td><strong>Name</strong></td><td><strong>Description</strong></td><td><strong>Default</strong></td></tr>
  <tr><td><code>head</code></td><td>The manager node</td><td><em>None</em></td></tr>
  <tr><td><code>role</code></td><td>The role of this node</td><td><em>None</em></td></tr>
  <tr><td><code>password</code></td><td>Condor pool password</td><td><code>undef</code></td></tr>
  <tr><td><code>slots</code></td><td>Condor slots per machine (&le; #CPUs)</td><td><code>32</code></td></tr>
  <tr><td><code>collectors</code></td><td>Number of collector daemons</td><td><code>undef</code></td></tr>
  <tr><td><code>node_type</code></td><td><code>NodeType</code> startd attribute</td><td><code>undef</code></td></tr>
  <tr><td><code>use_gsi_security</code></td><td>Turn on GSI security</td><td><code>false</code></td></tr>
  <tr><td><code>debug</code></td><td>Turn on debug logging</td><td><code>undef</code></td></tr>
</table>
