# Class: autofs
#
#  This is a base installation of autofs
#
#  autofs is ...
#
# Parameters:
#    NONE
#
# Actions:
#   - installs autofs
#   - setup cvmfs
#
# Requires:
#   - This has been tested on CentOS6

class autofs
{
  include packagerepos

  if $osvariant != 'CernVM' {
    package { 'autofs':
      ensure => installed,
      require => Class[Packagerepos]
    }
  }
}
