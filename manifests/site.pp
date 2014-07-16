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
    override_hostname  => $::hostname,
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

  ssh_authorized_key {'mike_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAsuHZK7hb5Ve0Q7FHhGd7cUjW+33ZUSkjkSgQ3TvQ5ZMQpRoLenkm/OBxP93gIFNwsdQqbGiMpusfiaJ5Vx/SUdeRX/9P0ULNxkYK4fxUIzOEXSeiUojKvxUMGQjM4fUR8CASKNYnxL65MSYIFrvuOT3Au19fRlv3napXzbvMbjYtOgWdjaZQWfvFUBVtZTASRafBMw44uf9Y/Av2gnD2OlxQ7ijq9zhda2wFLDe4LYDHIzb5NsU7YcYceSMf1dSjiQPMT+bMgvfQmqxD+M5jL+w51sFwuxQCK4UUQfsvv971ewyCHQ+kB8CzrLGfSCkHXeTvOOC0GY8FWC54B6D7RQ==',
    type   => ssh-rsa,
    user   => root,
  }

  ssh_authorized_key {'ian_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEArCq5+hUgS0UVsgZ+U/u12Fi2c+iOFimsfcv8JYODraSCjRSslJb110fLD6NPDk/8xm2C2gxqBar8tK2zZaftS4LYwtTY/8qMGCyf5O+8uCVuJztUt3V3m9TtAAp8pKX6aqhASOOW/IFfkodbt/6XwjGiCf5QPs8cHdh7S4zR4dJ9N154uDQkIs2meuX/SYZktkRz6qbo0pYceGZTh8TV5lGYUN6iZefV40lx/p+3BlRmC7NcaG+HGf4KpczHpofgp096sSoiIKlZm4rpcNxNMnNPLoCCP6w2eRDS1V7hDVIO2rF1i+OrkgEDPqf1dx/Q3911NcbawwdaS/ssB+jPFw==',
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

  ssh_authorized_key {'ron_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDBIEzhK55a8yix8HwM0Ni3/LmgjqZjlw8vB1n4JjkS9W2luFEP7Kb690fImuPJXCqW2VnUjfP17bzBS81n5ijJghD4fnIFUCNUd9Z61uSCojIKvTUW1foGXbrvCsOMdraFlUW/OUFBQn011pVRVBf3p74RFoqx01RKOJQ404akxOJFW0a2aibHqPwPOjgRs33TXg3LrRRmFzJNbu1HFpp2TgyndgvmKXmxNFwjJi4EP3I2ZDO6BBvZKQpiS/29sNvkyyv+vNC9ObeXF5yM1EAKuN1QI+Kw4H4GBrPq9O6eJbrcFhv3U7NLIFpaEgi6HVrcwPw3cbD3R49u7jDRtY+1',
    type   => ssh-rsa,
    user   => root,
  }

  ssh_authorized_key {'matt_key':
    ensure => present,
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCulnicGn2nzpWJ/njcPsU9v+KMmOvwhMZpGW1lTpNDNAItyNAr3KDGz0FXu0df2Q0Z4LOfrRYl6xldZdaZ0GsL31mkrvG3DF5qq8x8Y+M8nArt/V3JjIiUF6MUWiHLZMfNJOP1fKMdHS2vQyQHnFTI+ss7VbQGNVfGUd6vq7jN8EjtptqKAAFg8Vl6pI1ccrmLgB4xiLSnWQ81s374y3+egjiqxfzykMbJ+2kV9c4YVG9ApGOf7Hqn6vWL9RMUeKenvXsIcxtCHez+NUE/jZFsVn3ceEFZO7EeEWeCM6a2npdcc2FzXj7LrgESfQyGtypWTnwn4OfOmzNwqusV4Le9',
    type   => ssh-rsa,
    user   => root,
  }

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

