# gce_node
## Description

The *gce_node* module is an umbrella module that collects the configuration of the services for the different roles in one place.

## Operating system support

Software package installation is only supported on RedHat based system but the configuration should work everywhere.

## Contents

The *gce_node* module does the following:

* Installs compatibility packages for running SLC5 binaries on SLC6
* Writes the grid setup profile to `/etc/profile.d/grid-setup.sh`
* Sets up the [cvmfs](https://github.com/spiiph/atlasgce-modules/tree/master/autofs) module with `repositories => 'atlas.cern.ch,atlas-condb.cern.ch'`
* Sets up the [xrootd](https://github.com/spiiph/atlasgce-modules/tree/master/xrootd) module
* Sets up the [condor](https://github.com/spiiph/atlasgce-modules/tree/master/condor) module
* Sets up the [apf](https://github.com/spiiph/atlasgce-modules/tree/master/apf) module (`head` role)

## Variables and defaults

Here are some notable variables and their default values

<table>
  <tr><td><strong>Name</strong></td><td><strong>Description</strong></td><td><strong>Default</strong></td></tr>
  <tr><td><code>head</code></td><td>The manager node of the cluster</td><td><em>None</em></td></tr>
  <tr><td><code>role</code></td><td>The role of this node</td><td><em>None</em></td></tr>
  <tr><td><code>use_cvmfs</code></td><td>Use the <em>cvmfs</em> module</td><td><code>true</code></td></tr>
  <tr><td><code>condor_password</code></td><td>Condor pool password</td><td><code>undef</code></td></tr>
  <tr><td><code>condor_use_gsi</code></td><td>Turn on GSI security</td><td><code>false</code></td></tr>
  <tr><td><code>condor_slots</code></td><td>Condor slots per machine (&le; #CPUs)</td><td><em>None</em></td></tr>
  <tr><td><code>use_xrootd</code></td><td>Use the <em>xrootd</em> module</td><td><code>true</code></td></tr>
  <tr><td><code>xrootd_global_redirector</code></td><td>XRootD redirector for external requests</td><td><code>undef</code></td></tr>
  <tr><td><code>atlas_site</code></td><td>The ATLAS site name, as used in the grid setup</td><td><code>undef</code></td></tr>
  <tr><td><code>use_apf</code></td><td>Use the <em>apf</em> module</td><td><code>true</code></td></tr>
  <tr><td><code>panda_site</code></td><td>The PanDA site name</td><td><em>None</em></td></tr>
  <tr><td><code>panda_queue</code></td><td>The PanDA queue name</td><td><em>None</em></td></tr>
  <tr><td><code>panda_cloud</code></td><td>The PanDA cloud that the site belongs to</td><td><em>None</em></td></tr>
  <tr><td><code>panda_adminstrator_email</code></td><td>Administrator email for APF</td><td><em>None</em></td></tr>
  <tr><td><code>http_server_address</code></td><td>HTTP server address for logs</td><td><em>None</em></td></tr>
  <tr><td><code>debug</code></td><td>Turn on debug logging</td><td><code>undef</code></td></tr>
</table>

