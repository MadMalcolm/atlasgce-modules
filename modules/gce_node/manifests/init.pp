# class: gce_node
#
#  The gce_node class is an umbrella class for the cvmfs, xrootd, and condor
#
# Parameters:
#   - $head: FQDN of Condor Central Manager and XRootD redirector
#   - $role: Role of this node (head or worker)
#   - $condor_pool_password: Condor pool password
#   - $condor_slots: Number of job slots in the cluster and unique analysis
#                    accounts
#   - $xrootd_global_redirector: Address of the global XRootD redirector
#
# Actions:
#   - Installs extra packages from SLC6, CERN EPEL, and other repositories
#   - Configures the CVMFS, XRootD, Condor
#
# Requires:
#   - This has been tested on CentOS6
#
# Author: Henrik Öhman <ohman@cern.ch>

class gce_node {
  notify {"Running worker node manifest.":}
}
