# class: gce_node
#
#  The gce_node class is an umbrella class for the cvmfs, xrootd, condor, and
#  APF services on an ATLAS analysis node running in GCE.
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
#   - Configures the CVMFS, XRootD, Condor, and APF services
#
# Requires:
#   - This has been tested on CentOS6
#
# Author: Henrik Öhman <ohman@cern.ch>

class gce_node (
  $head,
  $role,
  $use_ephemeral = true,
  $use_cvmfs = true,
  $cvmfs_domain_servers = undef,
  $cvmfs_quota = 20000,
  $cvmfs_cache = '/var/cache/cvmfs2',
  $condor_pool_password = undef,
  $condor_use_gsi = false,
  $condor_slots,
  $condor_vmtype = undef,
  $condor_homedir = '/var/lib/condor',
  $use_xrootd = true,
  $xrootd_global_redirector = undef,
  $xrootd_scratch = '/data/scratch',
  $use_apf = true,
  $apf_homedir = '/var/lib/apf',
  $panda_site = undef,
  $panda_queue = undef,
  $panda_cloud = undef,
  $panda_administrator_email = undef,
  $atlas_site = undef,
  $cloud_type_in = undef,
  $debug = false
){

  # Use cloud_type fact if cloud_type is not specified
  if $cloud_type_in != undef {
    $cloud_type = $cloud_type_in
  } else {
    $cloud_type = $::cloud_type
  }

  class { 'gce_node::packages':
    install_32bit_packages => false,
    install_slc6_packages => false,
  }

  class { 'gce_node::grid_setup':
    atlas_site => $atlas_site,
    use_gridftp2 => $role ? {
      'csnode' => true,
      default => false,
    },
  }

  class {'gce_node::clock_setup': }

  if $use_ephemeral {
    class { 'gce_node::ephemeral':
      cloud_type => $cloud_type,
      role => $role,
      cvmfs_cache => $cvmfs_cache,
      condor_homedir => $condor_homedir,
      apf_homedir => $apf_homedir,
      xrootd_scratch => $xrootd_scratch,
    }
  }

  if $use_cvmfs == true {
    class {'cvmfs':
      cachedir => $cvmfs_cache,
    }  

    class { 'cvmfs::client':
      repositories => 'atlas.cern.ch,atlas-condb.cern.ch,grid.cern.ch',
      cvmfs_servers => $cvmfs_domain_servers,
      quota => $cvmfs_quota,
      debug => $debug,
    }
  }

  if $use_xrootd == true {
    class { 'xrootd::client':
      redirector => $head,
      role => $role,
      global_redirector => $xrootd_global_redirector,
      oss_localroot => $xrootd_scratch,
      debug => $debug,
    }
  }

  class { 'condor':
    homedir => $condor_homedir,
  }
  
  class { 'condor::client':
      head => $head,
      role => $role,
      password => $condor_pool_password,
      use_gsi_security => $condor_use_gsi,
      slots => $condor_slots,
      vmtype => $condor_vmtype,
      cloud_type => $cloud_type,
      debug => $debug,
  }

  if $osvariant == 'CernVM' {
    class { 'cernvm': }
  }

  if $role == 'head' and $use_apf == true {
    class { 'apf::client':
      panda_site => $panda_site,
      panda_queue => $panda_queue,
      panda_cloud => $panda_cloud,
      factory_id => 'atlasgce_factory',
      admin_email => $panda_administrator_email,
      http_server_address => gce_metadata_query('instance/network-interfaces/0/access-configs/0/external-ip'),
      homedir => $apf_homedir,
      debug => $debug,
    }
  }

  if $role == 'csnode' {
    sysctl {'net.core.rmem_max': value => "16777216" }
    sysctl {'net.core.wmem_max': value => "16777216" }
    sysctl {'net.ipv4.tcp_rmem': value => "4096 87380 16777216" }
    sysctl {'net.ipv4.tcp_wmem': value => "4096 65536 16777216" }
    sysctl {'net.core.netdev_max_backlog': value => "30000" }
    sysctl {'net.ipv4.tcp_timestamps': value => "1" }
    sysctl {'net.ipv4.tcp_sack': value => "1" }

    exec {'ip link set eth0 txqueuelen 10000': path => '/sbin' }

    class {'shoal':
      require => Class['cvmfs::client'],
    }
  }
}
