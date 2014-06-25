# Class: xrootd
#
#  This is a base installation of xrootd
#
#  Xrootd is a high performance network storage system widely used in high energy
#  physics experiments such as ATLAS and ALICE. The underlying Xroot data transfer
#  protocol provides highly efficient access to ROOT based data files. This class provides
#  the basis for creating a simple Xrootd storage system consisting of one
#  redirector node and one or more data server nodes.
#
# Parameters:
#    $user: XrootD user
#    $group: XrootD group
#    $homedir: XrootD user home directory
#    $rundir: XrootD run directory
#    $logdir: XrootD log directory
#
# Actions:
#   - installs xrootd-server
#   - setup xrootd user and group
#   - setup xrootd log dir
#
# Requires:
#   - This has been tested on CentOS6
#
# Author: Val Hendrix <vchendrix@lbl.gov>
# Modified for GCE: Henrik Öhman <ohman@cern.ch>

class xrootd (
    $user = 'xrootd',
    $group = 'xrootd',
    $homedir = '/var/spool/xrootd',
    $rundir = '/var/run/xrootd',
    $logdir = '/var/log/xrootd'
){
  include packagerepos

  if $osvariant != 'CernVM' {
    package { ['xrootd']:
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
    comment => 'XRootD runtime user',
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
    ensure => directory,
    owner => $user,
    group => $group,
    mode => 0755,
    require => [Group[$group], User[$user]],
  }
}
