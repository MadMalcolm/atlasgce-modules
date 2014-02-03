# module; shoal
#
# Installes, Configures and executes shoal client on RHEL.  Presumed installed on
# CernVM, it is installed over yum for RHEL.
#
# Parameters:
#    - server: shoal server to connect to
#    - cvmfs_config: cernvmfs configuration file to insert proxies to

class shoal (
  $server = 'http://shoal.heprc.uvic.ca/nearest',
  $cvmfs_config = '/etc/cvmfs/default.local'
)
{

  # Install shoal-client
  if $osvariant == 'CernVM' {
    
    info('On CernVM, assuming shoal is installed.')
    
  } elsif $osfamily == 'RedHat' {
  
    yumrepo { 'shoalrepo':
        descr    => "Shoal Repository",
        baseurl  => "http://shoal.heprc.uvic.ca/repo/prod/",
        gpgcheck => 0,
        enabled  => 1,
    }
    
    package { 'shoal-client':
      ensure => installed,
      require => Yumrepo['shoalrepo'],
    }

  }

  # -- ensure the shoal configuration directory exists --
  file {'/etc/shoal':
    ensure => directory,
    mode => 0755,
    before => File['/etc/shoal/shoal_client.conf']
  }
  
  # configure shoal-client
  file {'/etc/shoal/shoal_client.conf':
    ensure => present,
    mode => 0644,
    content => template("shoal/shoal_client.conf.erb"),
  }

  cron {'shoalclient':
    command => '/usr/bin/shoal-client',
    user    => root,
    minute  => [ 0, 30 ],
    require => [ File['/etc/shoal/shoal_client.conf'],
                 File[$cvmfs_config] ],
  }
  
}
