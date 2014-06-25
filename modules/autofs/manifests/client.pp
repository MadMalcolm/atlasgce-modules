# Class: autofs::client
#
#  This is a base installation of autofs
#
#  autofs is ...
#
# Parameters:
#   $master_conf: Location of auto.master file
#   $mounts: Paths to mounts to add to the master file
#
# Actions:
#   - creates /etc/auto.master
#   - creates /etc/auto.<name> for each mount point in mounts
#   - starts the autofs service
#
# Requires:
#   - This has been tested on CentOS6
#

class autofs::client(
    $master_conf = '/etc/auto.master',
    $mounts = undef
) inherits autofs
{
  file { $master_conf:
    owner => 'root',
    group => 'root',
    mode => 0644,
    content => template('autofs/auto.master.erb'),
  }

  service { 'autofs':
    enable => true,
    ensure => running,
    require => Class[autofs],
    subscribe => File[$master_conf],
  }
}

# Class for creating extra mounts
class autofs::mount(
  $name,
  $domain,
  $path
)
{
  file { $path:
    ensure => file,
    owner => 'root',
    group => 'root',
    mode => 0644,
    content => template('autofs/auto.mount.erb'),
    notify => Service[autofs],
  }
}
