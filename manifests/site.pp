################################################################################
node atlas-worker.heprc.uvic.ca.pem {
  
  class { 'gce_node::atlas':
    cvmfs_cache    => '/var/cache/cvmfs2',
    condor_homedir => '/var/lib/condor',
  }
  
}


################################################################################
node default {
  
  class { 'gce_node::atlas':
    cvmfs_cache    => '/var/cache/cvmfs2',
    condor_homedir => '/var/lib/condor',
  }
  
}
