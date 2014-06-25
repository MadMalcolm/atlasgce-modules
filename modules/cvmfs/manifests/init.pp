# Class: cvmfs
#
#  This is a base installation of cvmfs
#
#  CVMFS is ...
#
# Parameters:
#    $user: CVMFS user
#    $group: CVMFS group
#    $homedir: CVMFS user home directory
#    $logdir: CVMFS log dir
#    $cachedir: CVMFS cache directory
#    $rundir: CVMFS run directory
#
# Actions:
#   - installs cvmfs
#   - setup cvmfs
#
# Requires:
#   - This has been tested on CentOS6
#

class cvmfs (
    $user = 'cvmfs',
    $group = 'cvmfs',
    $homedir = '/var/lib/cvmfs',
    $logdir = '/var/log/cvmfs',
    $cachedir = '/var/cache/cvmfs2',
    $rundir = '/var/run/cvmfs'
)
{
  include packagerepos

  if $osvariant != 'CernVM' {
    package { ['cvmfs', 'cvmfs-init-scripts', 'cvmfs-keys', 'cvmfs-auto-setup']:
      ensure => installed,
      require => Class[Packagerepos]
    }
  }

  group { $group:
    ensure => present,
    system => true,
  }

  user { $user:
    ensure => present,
    gid => $group,
    shell => '/sbin/nologin',
    home => $homedir,
    comment => 'CernVM-FS service account',
    managehome => true,
    system => true,
    require => Group[$group],
  }

  file { $homedir:
    ensure => 'directory',
    owner => $user,
    group => $group,
    mode => 0755,
    require => [Group[$group], User[$user]],
  }

  file { $logdir:
    ensure => 'directory',
    owner => $user,
    group => $group,
    mode => 0755,
    require => [Group[$group], User[$user]],
  }

  file { $cachedir:
    ensure => 'directory',
    owner => $user,
    group => $group,
    mode => 0755,
    require => [Group[$group], User[$user]],
  }
}
