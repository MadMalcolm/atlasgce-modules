# atlasgce-modules
## Description

The *atlasgce-modules* are  Puppet modules for contextualizing analysis clusters for the [ATLAS Experiment](http://atlas.ch/). They are developed primarily for [Google Compute Engine (GCE)](https://cloud.google.com/products/compute-engine).

## Operating system support

The modules have been tested on the [CentOS 6](http://www.centos.org/) operating system. It should work out of the box for most [RedHat](http://www.redhat.com/) based systems of the same generation, such as [SL6](https://www.scientificlinux.org/) and [SLC6](http://linux.web.cern.ch/linux/scientific6/).

Work is also in progress to partially support [CernVM](http://cernvm.cern.ch/). The SLC5 based CernVM 2.6 and 2.7 will have support for all modules except [packagerepos](https://github.com/spiiph/atlasgce-modules/tree/master/yumrepos) (due to lack of [Conary](http://wiki.rpath.com/wiki/Conary) support in Puppet) and [cvmfs](https://github.com/spiiph/atlasgce-modules/tree/master/autofs) (which is already configured during the CernVM contextualization). [μCernVM](http://cernvm.cern.ch/portal/ucernvm) will be SLC6 based and use RPM for package management and should be fully supported.

[Debian](http://www.debian.org/) based systems are not supported but support can be added.

## Cloud support

These modules have been developed for GCE but support for other clouds can be impemented.

# Functionality

## Overview

The *atlasgce-modules* provide from-scratch contextualization on bare machines (virtual or physical) for [ATLAS](http://atlas.ch) analysis.

Three different roles are available: The manager role (`head`), the worker role (`node`), and the worker role for a [Cloud Scheduler](http://cloudscheduler.org/) environment (`csnode`).

## The manager role (`head`)

The manager role consists of the following elements:

* The [AutoPyFactory](https://svnweb.cern.ch/trac/panda/browser/panda-autopyfactory) service fetches jobs from a [PanDA](https://twiki.cern.ch/twiki/bin/viewauth/AtlasComputing/Panda) queue and submits them locally to Condor.
* The [Condor](http://research.cs.wisc.edu/htcondor/) collector, negotiator, and schedd services manage job submission and the distribution of subjobs over the worker nodes.
* The [XRootD](http://xrootd.slac.stanford.edu/) and Cluster Management services act as a local XRootD redirector and are responsible for accessing and caching input data files through the [Federated ATLAS XRootD system](https://twiki.cern.ch/twiki/bin/view/AtlasComputing/AtlasXrootdSystems). (Optional)
* The [CernVM-FS](http://cernvm.cern.ch/portal/filesystem) service provides consistent access to ATLAS software. CernVM-FS is not strictly required for the manager role, but can be helpful when debugging the Condor services. (Optional)
* [Compatibility packages](https://twiki.cern.ch/twiki/bin/view/AtlasComputing/RPMCompatSLC6) for running SLC5 binaries on SLC6.

## The worker role (`node`)

The worker role consists of the following elements:

* The [Condor](http://research.cs.wisc.edu/htcondor/) startd service runs the individual subjobs as dictated by the manager.
* The [XRootD](http://xrootd.slac.stanford.edu/), Cluster Management, and File Residency Management services are responsible for accessing input data files through the manager and download those that are not yet available in the cache.
* The [CernVM-FS](http://cernvm.cern.ch/portal/filesystem) service provides consistent access to ATLAS software.
* [Compatibility packages](https://twiki.cern.ch/twiki/bin/view/AtlasComputing/RPMCompatSLC6) for running SLC5 binaries on SLC6.

## The Cloud Scheduler worker role (`csnode`)

The Cloud Scheduler worker role consists of the following elements:

* The [Condor](http://research.cs.wisc.edu/htcondor/) startd service runs the individual subjobs as dictated by the Cloud Scheduler.
* The [CernVM-FS](http://cernvm.cern.ch/portal/filesystem) service provides consistent access to ATLAS software.
* [Compatibility packages](https://twiki.cern.ch/twiki/bin/view/AtlasComputing/RPMCompatSLC6) for running SLC5 binaries on SLC6.

# Contextualization

The contextualization of the machine is governed by [Puppet](http://puppetlabs.com/) through the means of a public collection of modules (the *atlasgce-modules*, this repository) and one or more scripts for bootstrapping.

## Bootstrapping

The standard way of bootstrapping GCE images is to use a [startup script](https://developers.google.com/compute/docs/howtos/startupscript), and this method is used for the manager and worker nodes.

For Cloud Scheduler worker nodes startup scripts are not supported, and bootstrapping is instead achieved using a machine image that is prepared with software that downloads and runs a bootstrap script supplied through the `userdata` metadata attribute. (Cloud Scheduler might support startup scripts on GCE in the future.)

See [*atlasgce-scripts*](https://github.com/spiiph/atlasgce-scripts/) for more information on the bootstrapping procedure.

## What is contextualized?

The *atlasgce-modules* in combination with the bootstrapping procedure handles contextualization of everything from preparing and mounting additional storage, to add package repositories and download required software, to create and setup user accounts for services, and to configure and start the supported services.

This contextualization is done on a bare machine, meaning that no software other than  the package manager is required. Even Puppet is installed during the bootstrapping procedure.

This means that the extra work of preparing machine images with the required software and configurations, with the rather high turn-around time that comes with it, is effectively abolished. The extra cost of redoing the contextualization at instantiation has been found to be very small on GCE.

## Puppet

See [What is Puppet?](https://puppetlabs.com/puppet/what-is-puppet/)

# Usage

This section describes suggested usage together with the [*atlasgce-scripts*](https://github.com/spiiph/atlasgce-scripts/). It describes how to configure GCE options, how to configure the node template and other parts of the bootstrapping procedure, and how to start, update, and stop a cluster.

_Note: Configuration of the GCE project including adding SSH keys and configuring the firewall for incoming traffic (if necessary) is not covered here. Refer to the official [documentation](https://developers.google.com/compute/)._

_Note: Detailed information about configurable parts of the_ atlasgce-scripts _can be found in its [documentation](https://github.com/spiiph/atlasgce-scripts/)._

## Getting started

1. Download *atlasgce-scripts*

```
git clone https://github.com/spiiph/atlasgce-scripts.git
```

2. Download *atlasgce-modules* (Optional)

```
git clone https://github.com/spiiph/atlasgce-modules.git
```

3. Enter the `atlasgce-scripts` directory and edit [`defaults.sh`](https://github.com/spiiph/atlasgce-scripts/blob/master/defaults.sh) to change the GCE configuration to reflect your project and cluster
4. Edit the [`gce_node_head.pp`](https://github.com/spiiph/atlasgce-scripts/blob/master/gce_node_head.pp) and [`gce_node_worker.pp`](https://github.com/spiiph/atlasgce-scripts/blob/master/gce_node_worker.pp) to configure important options such as role, manager node address, XRootD redirector, PanDA settings, etc.
5. Edit [`mount-head.sh`](https://github.com/spiiph/atlasgce-scripts/blob/master/mount-head.sh) and [`mount-worker.sh`](https://github.com/spiiph/atlasgce-scripts/blob/master/mount-worker.sh) to match your disk setup. (Remember to change the mounts in `gce_node_head.pp` and `gce_node_worker.pp` accordingly.)
6. Edit [`modules.sh`](https://github.com/spiiph/atlasgce-scripts/blob/master/modules.sh) if you want to download the module repository in a non-standard way. _Note: if the repository format is changed from **git** to something else, the `update-cluster.sh` script also has to be updated._

## Managing the cluster

Once the node template and bootstrapping procedure has been configured three commands are used to control the cluster. These commands read information they require (such as GCE project, number of worker nodes in the cluster, etc.) from [`defaults.sh`](https://github.com/spiiph/atlasgce-scripts/blob/master/defaults.sh).

* `start-cluster.sh` &mdash; starts a manager node and worker nodes
* `stop-cluster.sh` &mdash; deletes the manager node and worker nodes
* `update-cluster.sh` &mdash; fetches updates to the module repository to each node and and applies them

# Contents

## Detailed module documentation

See the documentation in each subdirectory for detailed information about each module.

## packagerepos

The [packagerepos](https://github.com/spiiph/atlasgce-modules/tree/master/yumrepos) module manages package repositories containing extra software and compatibility libraries required to run ATLAS software. These include the SLC repositories and repositories for HT Condor, CernVM-FS, and AutoPyFactory.

## autofs and cvmfs

The [autofs](https://github.com/spiiph/atlasgce-modules/tree/master/autofs) and [cvmfs](https://github.com/spiiph/atlasgce-modules/tree/master/cvmfs) repositories manage the the CernVM-FS configuration and the Autofs service.

## xrootd

The [xrootd](https://github.com/spiiph/atlasgce-modules/tree/master/xrootd) module manages configuration and services for XRootD, Cluster Management, and File Residency Management.

## condor

The [condor](https://github.com/spiiph/atlasgce-modules/tree/master/condor) module manages the HT Condor configuration and the collector, negotiator, schedd, and startd services.

## apf

The [apf](https://github.com/spiiph/atlasgce-modules/tree/master/apf) module manages the AutoPyFactory configuration and service.


## gce_node

The [gce_node](https://github.com/spiiph/atlasgce-modules/tree/master/gce_node) module is an umbrella module to configure a machine for one of the specified roles. It is responsible for installing compatibility packages and doing any contextualization that is not directly tied to any of the other modules.
