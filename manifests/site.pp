################################################################################
node default {

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

