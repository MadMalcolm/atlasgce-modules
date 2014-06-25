# --- ATLAS Worker ---
node 'atlas-worker.heprc.uvic.ca' {
  class { 'gce_node':
    experiment_in => 'atlas',
    head => 'to.be.contextualized.by.cloud.scheduler',
    role => 'csnode',
    use_cvmfs => true,
    condor_pool_password => undef,
    condor_use_gsi => true,
    condor_slots => $processorcount,
    use_xrootd => false,
    condor_vmtype => 'atlas-worker',
    condor_homedir => '/scratch',
    cvmfs_repositories => 'atlas.cern.ch,atlas-condb.cern.ch,atlas-nightlies.cern.ch,sft.cern.ch',
    cvmfs_quota => 10000,
    cvmfs_domain_servers => "http://cvmfs.racf.bnl.gov:8000/opt/@org@;http://cvmfs.fnal.gov:8000/opt/@org@;http://cvmfs-stratum-one.cern.ch:8000/opt/@org@;http://cernvmfs.gridpp.rl.ac.uk:8000/opt/@org@;http://cvmfs02.grid.sinica.edu.tw:8000/opt/@org@"
  }

  #ssh_authorized_key {'frank_key':
  #  ensure => present,
  #  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDYwVT+a4+GbQd0ZZY9o/I94T2BQEjpYTV3SM6TgWmtosG7gPZa0LmCSJWDmApHVIw/b6Q6xBVMJvmslRblHpW3vMs5LE2CVTWguXZbp4dKwEeZxPjcdMKPgl9VO2LB2fnltjnvMNsPdzMVviTaQoMhwvRB/vsAW0Mbse5la0CJAogvb5EA++sRvsk+6ftpDTOC1YFdINtaRAUINYv8NwxnEKri82eWE0pV83xLoA4/+YdRRqhPStGRmRoRyn3u4vOdhLlzcBp85xTc56bLvquODYDOTR9NSRvQpCrWHdIXZwFUbMPW6+ONxbNQTE+47QYDgj2i4tq8DX6Z56Q3C5i5FNrbaARnq4ml+bOR/wqCoWmKK3A7vKi7ng/QZjQu0wi9YFT7roU4uXF1hdsFFuIp+zX9kArbbxG+YdE95Ubwfun1qtqKzJr1/QcBn3KZqcrVKzuS6F5lv9s9VP9Ic7Os4wkwAGr1OlhRszZNcMBW/fHXLIlOO59rJclKNX7I+yjhmYa7W+JKrJxCkwzxuTa9J25Loh9v5z9MH9xGGxuk1scmOO7R8wkJjpjgPJqbw6p6VcV8m3cs556BL7c50++JVP3WaJXEoqSRz4x2+qFSfoZdbmR+7iVoPkU83QW3Ae5FoIjU4H4eiAoTkPtftFbe8lIOWIabe5O7b267voisgQ==',
  #  user   => root,
  #}
}

################################################################################
# --- Belle II Worker ---
node 'belle-worker.heprc.uvic.ca' {
  class { 'gce_node':
    experiment_in => 'belle',
    head => 'to.be.contextualized.by.cloud.scheduler',
    role => 'csnode',
    use_cvmfs => true,
    condor_pool_password => undef,
    condor_use_gsi => true,
    condor_slots => $processorcount,
    use_xrootd => false,
    condor_vmtype => 'belle-worker',
    condor_homedir => '/scratch',
    cvmfs_repositories => 'belle.cern.ch,grid.cern.ch',
    cvmfs_quota => 12000,
    cvmfs_domain_servers => "http://cvmfs.racf.bnl.gov:8000/opt/@org@;http://cernvmfs.gridpp.rl.ac.uk:8000/opt/@org@;http://cvmfs-stratum-one.cern.ch:8000/opt/@org@;http://cvmfs-stratum1-kit.gridka.de/cvmfs/belle;http://cvmfs.fnal.gov:8000/opt/@org@"
  }
}

################################################################################
# --- test VM ---
node 'test-worker.heprc.uvic.ca' {
  class { 'gce_node':
    experiment_in => 'atlas',
    head => 'cloud.scheduler',
    role => 'csnode',
    use_cvmfs => true,
    condor_pool_password => undef,
    condor_use_gsi => true,
    condor_slots => $processorcount,
    use_xrootd => false,
    condor_vmtype => 'test-worker',
    condor_homedir => '/scratch',
    cvmfs_repositories => 'atlas.cern.ch,atlas-condb.cern.ch,atlas-nightlies.cern.ch,sft.cern.ch',
    cvmfs_quota => 10000,
    cvmfs_domain_servers => "http://cvmfs.racf.bnl.gov:8000/opt/@org@;http://cvmfs.fnal.gov:8000/opt/@org@;http://cvmfs-stratum-one.cern.ch:8000/opt/@org@;http://cernvmfs.gridpp.rl.ac.uk:8000/opt/@org@;http://cvmfs02.grid.sinica.edu.tw:8000/opt/@org@"
  }
}


################################################################################
# presume NA ATLAS Worker by default
node default {
  class { 'gce_node':
    experiment_in => 'atlas',
    head => 'to.be.contextualized.by.cloud.scheduler',
    role => 'csnode',
    use_cvmfs => true,
    condor_pool_password => undef,
    condor_use_gsi => true,
    condor_slots => $processorcount,
    use_xrootd => false,
    condor_vmtype => 'ucernvm',
    condor_homedir => '/scratch',
    cvmfs_repositories => 'atlas.cern.ch,atlas-condb.cern.ch,atlas-nightlies.cern.ch,sft.cern.ch',
    cvmfs_quota => 10000,
    cvmfs_domain_servers => "http://cvmfs.racf.bnl.gov:8000/opt/@org@;http://cvmfs.fnal.gov:8000/opt/@org@;http://cvmfs-stratum-one.cern.ch:8000/opt/@org@;http://cernvmfs.gridpp.rl.ac.uk:8000/opt/@org@;http://cvmfs02.grid.sinica.edu.tw:8000/opt/@org@"
  }
}

