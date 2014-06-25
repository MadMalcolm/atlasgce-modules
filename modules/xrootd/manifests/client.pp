# class: xrootd::client
#
#  XrootD is a high performance network storage system widely used in high
#  energy physics experiments such as ATLAS and ALICE. The underlying Xroot
#  data transfer protocol provides highly efficient access to ROOT based data
#  files. This class provides the basis for creating a simple Xrootd storage
#  system consisting of one redirector node and one or more data server
#  nodes.
#
#  This is the configuration for an ATLAS Tier 3 head/worker node. It is made
#  up of a redirector, data servers, and file residency managers for staging.
#
# Parameters:
#   - $redirector: Fully qualified domain name for the redirector
#   - $storage_path: Path for internal referencesath for internal references
#   - $oss_localroot: Local root for the data server inventories
#   - $global_redirector: FAX redirector used for staging
#   - $xrdport: Port for the XRootD daemon
#   - $debug: Turn on tracing for the XRootD daemons
#   - $config: XrootD config file path
#   - $sysconfig: XrootD system configuration file path
#   - $auth_file: XrootD authentication file
#   - $stagein: Script for staging from the global redirector
#
# Actions:
#   - sets up the storage directories, prepares configuration files for
#     XRootD, CMS, and FRM
#   - starts the xrootd, cmsd, xfr_frmd, and xfr_purged services
#
# Requires:
#   - This has been tested on CentOS6
#
# Author: Val Hendrix <vchendrix@lbl.gov>
# Modified for GCE: Henrik Öhman <ohman@cern.ch>

class xrootd::client (
  $redirector,
  $role,
  $storage_path = '/atlas',
  $oss_localroot = '/data/scratch',
  $global_redirector = 'atlas-xrd-eu.cern.ch',
  $xrdport = 1094,
  $debug = undef,
  $config = '/etc/xrootd/xrootd.cfg',
  $sysconfig = '/etc/sysconfig/xrootd',
  $auth_file = '/etc/xrootd/auth_file',
  $stagein = '/etc/xrootd/stagein.sh'
  ) inherits xrootd
{
  file { $sysconfig:
    owner => 'root',
    group => 'root',
    ensure  => present,
    content => template('xrootd/xrootd.sysconfig.erb'),
    require => Class['xrootd'],
  }

  file { $config:
    owner => $user,
    group => $group,
    ensure  => present,
    content => template('xrootd/xrootd.cfg.erb'),
    require => Class['xrootd'],
  }

  file { $auth_file:
    owner => $user,
    group => $group,
    ensure => present,
    content => template('xrootd/auth_file.erb'),
    require => Class['xrootd'],
  }

  # Configuration for a worker/cache node
  if $role == 'node' {
    file { $stagein:
      owner => $user,
      group => $group,
      mode => 0755,
      ensure => present,
      content => template('xrootd/stagein.sh.erb'),
      require => Class['xrootd'],
    }

    file { [$oss_localroot, "$oss_localroot$storage_path"]:
      owner => $user,
      group => $group,
      ensure => directory,
      recurse => true,
      require => Class['xrootd'],
    }

    $requires = [File["$oss_localroot$storage_path"]]

    service { 'frm_xfrd':
      ensure => running,
      enable => true,
      subscribe => File[$sysconfig, $config, $stagein],
      require => $requires,
     }

    service { 'frm_purged':
      ensure => running,
      enable => true,
      subscribe => $frm_subscribes,
      require => $requires,
     }
  } else {
    $requires = []
  }

  # Start the xrootd service
  service { 'xrootd':
    ensure => running,
    enable => true,
    subscribe => File[$sysconfig, $config, $auth_file],
    require => $requires,
   }

  # Start the cmsd service
  service { 'cmsd':
    ensure => running,
    enable => true,
    subscribe => File[$sysconfig, $config, $auth_file],
    require => $requires,
   }
}
