# Class cernvm
#
# This is a base configuration for the CERN Virtual Machine
#
# CernVM is a virtual machine based on Scientific Linux published by CERN.
#
# Parameters:
#   $cvmfs2: whether to use cvmfs2, may be on or off
#   $edition: CernVM edition, Basic, Desktop, Head
#   $organization: Organization the cernvm runs for, eg. atlas
#   $repositories: repositories (available of cvmfs), eg. atlas,atlas-condb,grid
#
# Actions:
#   - configures /etc/cernvm/site.conf
#
# Requires:
#   - must be running on a CernVM
#

class cernvm (
  $cvmfs2       = 'on',
  $edition      = 'Basic',
  $organization = 'atlas',
  $repositories = 'atlas,atlas-condb,grid',
  $confdir      = '/etc/cernvm',
  $siteconf     = '/etc/cernvm/site.conf'
)
{
  if $osvariant == 'CernVM' {
    file { $confdir:
      ensure => directory,
      mode   => 755,
      owner  => root,
      group  => root,
      before => File[$siteconf],
    }

    file { $siteconf:
      ensure => present,
      owner  => root,
      group  => root,
      mode   => 644,
      content => template('cernvm/site.conf.erb'),
    }
  }
}
