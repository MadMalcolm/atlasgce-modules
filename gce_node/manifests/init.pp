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

class gce_node (
  $head,
  $role,
  $use_ephemeral = true,
  $use_cvmfs = true,
  $cvmfs_domain_servers = undef,
  $cvmfs_quota = 20000,
  $cvmfs_cache = '/var/cache/cvmfs2',
  $cvmfs_repositories = 'atlas.cern.ch,atlas-condb.cern.ch,grid.cern.ch',
  $condor_pool_password = undef,
  $condor_use_gsi = false,
  $condor_slots,
  $condor_vmtype = undef,
  $condor_homedir = '/var/lib/condor',
  $use_xrootd = true,
  $xrootd_global_redirector = undef,
  $xrootd_scratch = '/data/scratch',
  $panda_site = undef,
  $panda_queue = undef,
  $panda_cloud = undef,
  $panda_administrator_email = undef,
  $atlas_site = undef,
  $cloud_type_in = undef,
  $experiment_in = 'atlas',
  $debug = false
){

  # Use cloud_type fact if cloud_type is not specified
  if $cloud_type_in != undef {
    $cloud_type = $cloud_type_in
  } else {
    $cloud_type = $::cloud_type
  }

  class { 'gce_node::packages':
    install_32bit_packages => true,
    install_slc6_packages => true,
  }

  class { 'gce_node::grid_setup':
    atlas_site => $atlas_site,
    use_gridftp2 => $role ? {
      'csnode' => true,
      default => false,
    },
    experiment => $::gce_node::experiment_in,
  }

  class {'gce_node::clock_setup': }

  if $use_ephemeral {
    class { 'gce_node::ephemeral':
      cloud_type => $cloud_type,
      role => $role,
      cvmfs_cache => $cvmfs_cache,
      condor_homedir => $condor_homedir,
      xrootd_scratch => $xrootd_scratch,
    }
  }

  if $use_cvmfs == true {
    class {'cvmfs':
      cachedir => $cvmfs_cache,
    }  

    class { 'cvmfs::client':
      repositories => $cvmfs_repositories,
      cvmfs_servers => $cvmfs_domain_servers,
      quota => $cvmfs_quota,
      debug => $debug,
      before => Class['condor::client'],
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

    class {'wlcg': }

    if $::gce_node::experiment_in == 'atlas' {
      # ganglia manifest
      #
      # this sets up ganglia reporting to CERN's hn-grizzly. Need
      # find a way to determine which cluster name which cloud should
      # report to
      $udp_recv_channel = [
        { port => 9006 },
      ]

      $udp_send_channel = [
        { port => 9006, host => 'hn-grizzly.cern.ch', ttl => 2 },
      ]

      $cluster_name = 'MULTI-CLUSTER_tmp'

      $tcp_accept_channel = [
        {port => 9006},
      ]

      class{ 'ganglia::gmond':
        cluster_name       => $cluster_name,
        cluster_owner      => 'unspecified',
        cluster_latlong    => 'unspecified',
        cluster_url        => 'unspecified',
        host_location      => 'CERN',
        udp_recv_channel   => $udp_recv_channel,
        udp_send_channel   => $udp_send_channel,
        tcp_accept_channel => $tcp_accept_channel,
      }
    }
  }
}
