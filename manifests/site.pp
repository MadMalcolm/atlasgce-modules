################################################################################
node default {

  
  class { 'gce_node::atlas':
    cvmfs_cache    => '/var/cache/cvmfs2',
    condor_homedir => '/var/lib/condor',
  }
  
}
