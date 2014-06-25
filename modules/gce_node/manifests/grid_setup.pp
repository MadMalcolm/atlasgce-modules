class gce_node::grid_setup (
  $atlas_site = undef,
  $use_gridftp2 = false,
  $use_emi_grid_software = true,
  $setup_file = '/etc/profile.d/grid-setup.sh',
  $security_dir = '/etc/grid-security',
  $experiment = 'atlas'
)
{
  
  file { $setup_file:
    owner => 'root',
    group => 'root',
    mode => 0644,
    content => template("gce_node/grid-setup.sh.${experiment}.erb"),
  }

  if $gce_node::role == 'csnode' {
    file { $security_dir:
      ensure => directory,
      owner => root,
      group => root,
      mode => 0755,
      replace => false,
    }
    
    file { 'hostcert.pem':
      path => "${security_dir}/hostcert.pem",
      ensure => present,
      owner => root,
      group => root,
      mode => 0644,
      require => File[$security_dir],
    }

    file { 'hostkey.pem':
      path => "${security_dir}/hostkey.pem",
      ensure => present,
      owner => root,
      group => root,
      mode => 0600,
      require => File[$security_dir],
    }
    
    file { 'certificates':
      path => "${security_dir}/certificates",
      ensure => directory,
      owner => root,
      group => root,
      mode => 0755,
      replace => false,
      require => File[$security_dir],
    }

    yumrepo { 'EGI-trustanchors':
      descr    => "EGI-trustanchors",
      baseurl  => "http://repository.egi.eu/sw/production/cas/1/current/",
      gpgkey   => "http://repository.egi.eu/sw/production/cas/1/GPG-KEY-EUGridPMA-RPM-3",
      gpgcheck => 1,
      enabled  => 1,
    }

    package { 'ca-policy-egi-core':
      ensure  => installed,
      require => Yumrepo['EGI-trustanchors'],
    }

  }
  
}
