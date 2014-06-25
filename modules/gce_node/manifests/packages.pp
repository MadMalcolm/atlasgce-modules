class gce_node::packages (
  $install_32bit_packages,
  $install_slc6_packages
)
{
  # Don't know how to handle conary packages, so don't install any for CernVM
  if $osvariant != 'CernVM' {

    # Required 64 bit packages and packages for SLC5 64 bit compatibility
    package { ['openssl098e.x86_64']:
      ensure => installed,
    }

    package { 'xrootd-client':
      ensure => installed,
    }

    # Subversion required for RootCore etc.
    package { 'subversion':
      ensure => installed,
    }
    
    # Packages from the SLC6 repos (64 bit versions)
    if $install_slc6_packages {
      package { ['castor-lib.x86_64', 'castor-devel.x86_64']:
        require => Class[Packagerepos],
        ensure => installed,
      }
    }

    if $install_32bit_packages {
      # Extra packages for SLC5 32-bit compatibility
      package { 'openssl098e.i686':
        ensure => installed,
      }

      if $install_slc6_packages {
      # Packages from the SLC6 repos (32 bit versions)
        package { ['castor-lib.i686', 'castor-devel.i686']:
          require => Class[Packagerepos],
          ensure => installed,
        }
      }
    }
  }
}

