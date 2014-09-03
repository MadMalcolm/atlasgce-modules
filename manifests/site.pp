################################################################################
node 'worker.heprc.uvic.ca' {
  
  class { 'gce_node::belle':
    cvmfs_cache    => '/var/cache/cvmfs2',
    condor_homedir => '/var/lib/condor',
  }
  
}
