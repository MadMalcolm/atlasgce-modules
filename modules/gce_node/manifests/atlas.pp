# class: atlas
#
#  The gce_node::atlas class is an umbrella class for the cvmfs, xrootd, and condor
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

class gce_node::atlas (
  $cvmfs_cache = '/var/cache/cvmfs2',
  $condor_homedir = '/var/lib/condor',
){

  class { 'gce_node::grid_setup':
    use_gridftp2 => true,
    experiment   => 'atlas',
  }

  class {'gce_node::clock_setup': }

  class { 'gce_node::ephemeral':
    cloud_type => $cloud_type,
    cvmfs_cache => $cvmfs_cache,
    condor_homedir => $condor_homedir,
  }

  class {'cvmfs':
    cachedir => $cvmfs_cache,
  }  

  class { 'cvmfs::client':
    repositories => 'atlas.cern.ch,atlas-condb.cern.ch,atlas-nightlies.cern.ch,sft.cern.ch',
    cvmfs_servers => 'http://cvmfs.racf.bnl.gov:8000/opt/@org@;http://cvmfs.fnal.gov:8000/opt/@org@;http://cvmfs-stratum-one.cern.ch:8000/opt/@org@;http://cernvmfs.gridpp.rl.ac.uk:8000/opt/@org@;http://cvmfs02.grid.sinica.edu.tw:8000/opt/@org@',
    quota => 10000,
    debug => false,
    before => Class['condor::client'],
  }

  class { 'condor':
    homedir => $condor_homedir,
  }
  
  class { 'condor::client':
    role => 'csnode',
    password => 'undefined',
    use_gsi_security => true,
    slots => 1,
    vmtype => 'atlas-worker',
    cloud_type => $cloud_type,
    debug => false,
  }

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

  # ---
  # ganglia reporting to CERN's atlas ganglia monitoring system
  if $::cloud_name == 'cern-atlas' {

    $cluster_name = 'CERN-PROD_CLOUD'
    $my_host_location = 'CERN'
    $udp_recv_channel = [{ port => 8649 }]
    $udp_send_channel = [{ port => 8649, host => 'atlas-ganglia-mon.cern.ch', ttl => 2 }]
    $tcp_accept_channel = [{port => 8649}]
    
  } elsif $::cloud_name == 'gridpp-oxford' or $::cloud_name == 'gridpp-imperial' {

    $cluster_name = 'GRIDPP_CLOUD'
    $my_host_location = 'UK'
    $udp_recv_channel = [{ port => 9000 }]
    $udp_send_channel = [{ port => 9000, host => 'atlas-ganglia-mon.cern.ch', ttl => 2 }]
    $tcp_accept_channel = [{ port => 9000 }]

  } else {

    $cluster_name = 'IAAS'
    $my_host_location = 'CA'
    $udp_recv_channel = [{ port => 9004 }]
    $udp_send_channel = [{ port => 9004, host => 'atlas-ganglia-mon.cern.ch', bind_hostname => 'yes', ttl => 2 }]
    $tcp_accept_channel = [{ port => 9004}]

  }

  class{ 'ganglia::gmond':
    cluster_name       => $cluster_name,
    cluster_owner      => 'unspecified',
    cluster_latlong    => 'unspecified',
    cluster_url        => 'unspecified',
    override_hostname  => $::fqdn,
    host_location      => $my_host_location,
    udp_recv_channel   => $udp_recv_channel,
    udp_send_channel   => $udp_send_channel,
    tcp_accept_channel => $tcp_accept_channel,
  }

  # ---
  # group ssh keys for access to workers for debugging
  ssh_authorized_key {'frank_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDYwVT+a4+GbQd0ZZY9o/I94T2BQEjpYTV3SM6TgWmtosG7gPZa0LmCSJWDmApHVIw/b6Q6xBVMJvmslRblHpW3vMs5LE2CVTWguXZbp4dKwEeZxPjcdMKPgl9VO2LB2fnltjnvMNsPdzMVviTaQoMhwvRB/vsAW0Mbse5la0CJAogvb5EA++sRvsk+6ftpDTOC1YFdINtaRAUINYv8NwxnEKri82eWE0pV83xLoA4/+YdRRqhPStGRmRoRyn3u4vOdhLlzcBp85xTc56bLvquODYDOTR9NSRvQpCrWHdIXZwFUbMPW6+ONxbNQTE+47QYDgj2i4tq8DX6Z56Q3C5i5FNrbaARnq4ml+bOR/wqCoWmKK3A7vKi7ng/QZjQu0wi9YFT7roU4uXF1hdsFFuIp+zX9kArbbxG+YdE95Ubwfun1qtqKzJr1/QcBn3KZqcrVKzuS6F5lv9s9VP9Ic7Os4wkwAGr1OlhRszZNcMBW/fHXLIlOO59rJclKNX7I+yjhmYa7W+JKrJxCkwzxuTa9J25Loh9v5z9MH9xGGxuk1scmOO7R8wkJjpjgPJqbw6p6VcV8m3cs556BL7c50++JVP3WaJXEoqSRz4x2+qFSfoZdbmR+7iVoPkU83QW3Ae5FoIjU4H4eiAoTkPtftFbe8lIOWIabe5O7b267voisgQ==',
    type   => ssh-rsa,
    user   => root,
  }

  ssh_authorized_key {'ryan_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC5nCWnNvXUGFgW+1cKinQhulovYs6qjjHTv3A1dRjWMuaXfqlz1udRJfTY/aU2qY9dU0slWFW8YKMx7Qdd3lE/YJ60hu8Q85ewLhwlBN8lNBExsCmiYrP7wOfyUZZgVU0cgEVt1sh0Uh9HhB0VXUUuRNcKt3hM0IM7DbHihbFIOv0/FLmNcWaVVJwtqtyMJoFxBl4Wfpk9xnk1sjrDVaBlxnFexIvifJhW0THY68yqpOapRv0+qgp0lecQWqIKgaGDssCGmi8Yq2Z3o4dZBzOZdJiAN0WHR+UPOfcLw86N0MjwBPOhOnWDnluF9Iys+gMxXj9jkXVhQDEMI8JHIShZ7gRuTkjeJ+1CHVXvBRck4vQQz83qHRQR8DFEofqN1h2a8zLQYQ9n310lxOo1LqS0k6qubrbzRIDweEv/Id/+WihhJvgEV9cho7xvm+Xf/s5k0X0xHKlgqCDh7lN6Aabr9s504xDu/HX+D2+w60HiGtZZC76pW5slCZWHlGNKC9C0l/Toe9UOiupD6JJKSHO6SQkZncSUYYuGWic/zYAImsaThvib9zkPU8j8bckxvvTccz6rP2dS7ASXjz0JFxoM9nKlvnFjRCQLxURrW90+w5Qz+rSeIEuzVOBig+qd+mxgG5awkq8+RrCX067oDl8GFy1RMDtoQGCu23SAkE80EQ==',
    type   => ssh-rsa,
    user   => root,
  }

  ssh_authorized_key {'peter_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA1PIVGbStuppnzgPJSWSj7EnXahodCgZIRDxCaWDudcJalTIenzU6zkvPbssWCpF3jnOihnGW6f5uZbxMs7SO/KARgwkqf85sy7T/ex9XjGC1g2k0cDd0cCadAuBbQZP34QY7JL7rDoWk5JLPxgJlGyNgVd5VLPB/ZLlofjVfugW6y889UrITBW451HT1WUgtNcK/jqEWjrPdPp6oX0ktMb79XMnmp80HJH9q1OM3s3WeUuEffjMsy2awMWCp+H8tkr6A6hp7bBWafoqmlHZlsnEcqKhBSxEa4QWGfvR1reCphuQJULQbpc8jU9kHvriGNvTT43DggE+pm43CTQ1Kiw==',
    type   => ssh-rsa,
    user   => root,
  }


  # -- swap space --
  $swap_size = 2 * $::physicalprocessorcount
  $swap_file = '/mnt/.rw/swap.1'
  exec { 'create swap file':
    command => "fallocate -l ${swap_size}G ${swap_file}",
    path    => "/bin:/usr/bin",
    unless  => "test -f ${swap_file}",
    
  }
  
  exec { 'make swap file':
    command => "mkswap ${swap_file}",
    path    => "/sbin:/usr/bin",
    require => Exec['create swap file'],
  }

  exec { 'mount swap file':
    command => "swapon ${swap_file}",
    path    => "/sbin:/usr/bin",
    require => Exec['make swap file'],
  }
  
}
