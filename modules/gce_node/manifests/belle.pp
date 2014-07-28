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

class gce_node::belle (
  $cvmfs_cache = '/var/cache/cvmfs2',
  $condor_homedir = '/var/lib/condor',
){

  class { 'gce_node::grid_setup':
    use_gridftp2 => true,
    experiment   => 'belle',
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
    repositories => 'belle.cern.ch,grid.cern.ch',
    cvmfs_servers => 'http://cvmfs.racf.bnl.gov:8000/opt/@org@;http://cernvmfs.gridpp.rl.ac.uk:8000/opt/@org@;http://cvmfs-stratum-one.cern.ch:8000/opt/@org@;http://cvmfs-stratum1-kit.gridka.de/cvmfs/belle;http://cvmfs.fnal.gov:8000/opt/@org@',
    quota => 12000,
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
    slots => $::processorcount,
    vmtype => 'belle-worker',
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
  # group ssh keys for access to workers for debugging
  ssh_authorized_key {'frank_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDYwVT+a4+GbQd0ZZY9o/I94T2BQEjpYTV3SM6TgWmtosG7gPZa0LmCSJWDmApHVIw/b6Q6xBVMJvmslRblHpW3vMs5LE2CVTWguXZbp4dKwEeZxPjcdMKPgl9VO2LB2fnltjnvMNsPdzMVviTaQoMhwvRB/vsAW0Mbse5la0CJAogvb5EA++sRvsk+6ftpDTOC1YFdINtaRAUINYv8NwxnEKri82eWE0pV83xLoA4/+YdRRqhPStGRmRoRyn3u4vOdhLlzcBp85xTc56bLvquODYDOTR9NSRvQpCrWHdIXZwFUbMPW6+ONxbNQTE+47QYDgj2i4tq8DX6Z56Q3C5i5FNrbaARnq4ml+bOR/wqCoWmKK3A7vKi7ng/QZjQu0wi9YFT7roU4uXF1hdsFFuIp+zX9kArbbxG+YdE95Ubwfun1qtqKzJr1/QcBn3KZqcrVKzuS6F5lv9s9VP9Ic7Os4wkwAGr1OlhRszZNcMBW/fHXLIlOO59rJclKNX7I+yjhmYa7W+JKrJxCkwzxuTa9J25Loh9v5z9MH9xGGxuk1scmOO7R8wkJjpjgPJqbw6p6VcV8m3cs556BL7c50++JVP3WaJXEoqSRz4x2+qFSfoZdbmR+7iVoPkU83QW3Ae5FoIjU4H4eiAoTkPtftFbe8lIOWIabe5O7b267voisgQ==',
    type   => ssh-rsa,
    user   => root,
  }

  ssh_authorized_key {'mike_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAsuHZK7hb5Ve0Q7FHhGd7cUjW+33ZUSkjkSgQ3TvQ5ZMQpRoLenkm/OBxP93gIFNwsdQqbGiMpusfiaJ5Vx/SUdeRX/9P0ULNxkYK4fxUIzOEXSeiUojKvxUMGQjM4fUR8CASKNYnxL65MSYIFrvuOT3Au19fRlv3napXzbvMbjYtOgWdjaZQWfvFUBVtZTASRafBMw44uf9Y/Av2gnD2OlxQ7ijq9zhda2wFLDe4LYDHIzb5NsU7YcYceSMf1dSjiQPMT+bMgvfQmqxD+M5jL+w51sFwuxQCK4UUQfsvv971ewyCHQ+kB8CzrLGfSCkHXeTvOOC0GY8FWC54B6D7RQ==',
    type   => ssh-rsa,
    user   => root,
  }

  ssh_authorized_key {'colin_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC0Np20Q4rFkI7E/Vi/08RHWm1i1PAdzXQ848ookdodofiIXuJBozoUgQmVfb/vtt8w7StpJ1Xkj3suXbFOyCW/iJbYPjve91o9Rxllfp0SPu6RV24nrhyCDOYO9DonAnVn4S9+aOVGXcP3+FbmfuvGCWf/QAKnpj+jo2adOO2Ynf/MhpSKMN/yY4lWOdCmAjh+cT7CbHRqFTmhKYBxa5qNR//VO2EGDtAZjSeath8JF0wxDvUBmRqmeoWhSDiYpUpk8kUpewSV23UyI/oVHHGL40wouUZKqU0ewR1gKHQhD9LmZbktXpF8S/Gxziqvsetv25KS4yCd6aFBmZ1byp+9',
    type   => ssh-rsa,
    user   => root,
  }

  ssh_authorized_key {'randy_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAucKrPQuzrcKDndD6hbETQr+KfkPiygCxYZH8Jjk1FX1mClEnF2+xFKZb93fbJoRsxOpKgUW21ADstwnb9x2+OGbWnQ3ii3Dz7Anh0M5UKfplrALGfip3GauuLmBeDl0jPJz7pDGSSzxUKcU9nDlO66Px6egWNaKXAExNxdVYAwO9+EFhZEHGns+/W8907dypn08Y4+MKnAN8DeNaHfwItDtzUPwTM1oUwFmatJ5rOyfYxli5oMFn6hcBEqa0Ol/I//UBDiPTjsvp4OIiW7t24plwfJhp00eKUoIhrpHGMajLYkdRiEzmethGkRQSa83dQV9hx/jYkiy8nXrCCmodiw==',
    type   => ssh-rsa,
    user   => root,
  }
  
}
