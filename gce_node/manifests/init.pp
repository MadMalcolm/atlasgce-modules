class gce_node (
  $head,
  $role,
  $condor_slots_per_node,
  $xrootd_global_redirector
){
  class { 'gce_node::packages':
    install_32bit_packages => false,
    install_slc6_packages => false,
  }

  class { 'cvmfs::client':
    repositories => 'atlas.cern.ch,atlas-condb.cern.ch',
  }

  class { 'xrootd::client':
    redirector => $head,
    role => $role,
    global_redirector => $xrootd_global_redirector,
  }

  class { 'condor::client':
      head => $head,
      role => $role,
      slots => $condor_slots_per_node,
  }
}
