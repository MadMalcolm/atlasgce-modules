# packagerepos
## Description

The *packagerepos* module manages package repositories containing extra software and compatibility libraries required to run ATLAS software. These include SLC repositories, CERN EPEL repositories, and repositories for HT Condor, CernVM-FS, and AutoPyFactory.

## Operating system support

This module only supports RedHat based operating system but tries to avoid
failing for other operating systems.

## Contents

The *packagerepos* module adds the following Yum repositories to RedHat based
systems:

* [SLC6](http://linux.web.cern.ch/linux/scientific6/) repositories (`slc6-os`, `slc6-updates`, `slc6-extras`, `slc6-cernonly`, `epel`, `epel-testing`)
* [CernVM-FS](http://cernvm.cern.ch/portal/filesystem) repositories (`cvmfs`, `cvmfs-testing`)
* [Condor](http://research.cs.wisc.edu/htcondor/) repositories (`htcondor`, `htcondor-development`)
* [AutoPyFactory](https://svnweb.cern.ch/trac/panda/browser/panda-autopyfactory) repositories (`racf-grid-production`, `racf-grid-testing`, `racf-grid-development`)
