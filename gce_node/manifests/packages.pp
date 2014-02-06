class gce_node::packages (
  $install_32bit_packages,
  $install_slc6_packages
)
{
  # Don't know how to handle conary packages, so don't install any for CernVM
  if $osvariant != 'CernVM' {
    # Required noarch packages
    package { ['automake', 'autoconf']:
      ensure => installed,
    }

    # Required 64 bit packages and packages for SLC5 64 bit compatibility
    package { ['glibc-devel.x86_64', 'openssl098e.x86_64', 'libtool',
               'freetype-devel.x86_64', 'libxml2-devel.x86_64',
               'ncurses-devel.x86_64', 'libpng-devel.x86_64', 'libXpm.x86_64',
               'libXext-devel.x86_64', 'libuuid-devel']:
      ensure => installed,
    }

    # Compatibility packages (64 bit versions)
    package { ['compat-libtermcap.x86_64', 'compat-readline5.x86_64',
               'compat-db43.x86_64', 'compat-expat1.x86_64',
               'compat-openldap.x86_64', 'ganglia-gmond']:
      ensure => installed,
    }

    # Packages from the SLC6 repos (64 bit versions)
    if $install_slc6_packages {
      package { ['castor-lib.x86_64', 'castor-devel.x86_64',
                 'mesa-libGL.x86_64', 'mesa-libGL-devel.x86_64',
                 'mesa-libGLU.x86_64', 'mesa-libGLU-devel.x86_64']:
        require => Class[Packagerepos],
        ensure => installed,
      }
    }

    if $install_32bit_packages {
      # Extra packages for SLC5 32-bit compatibility
      package { ['glibc.i686', 'glibc-devel.i686', 'libstdc++.i686',
                 'openssl098e.i686', 'freetype.i686', 'freetype-devel.i686',
                 'libxml2.i686', 'libxml2-devel.i686', 'libaio.i686',
                 'ncurses-devel.i686', 'libpng-devel.i686', 'libXpm.i686',
                 'libXext.i686', 'libXft.i686', 'libXext-devel.i686',
                 'pam.i686', 'java-1.7.0-openjdk']:
        ensure => installed,
      }

      # Compatibility packages (32 bit versions)
      package { ['compat-libtermcap.i686', 'compat-readline5.i686',
                 'compat-db43.i686', 'compat-expat1.i686',
                 'compat-openldap.i686']:
        ensure => installed,
      }

      if $install_slc6_packages {
      # Packages from the SLC6 repos (32 bit versions)
        package { ['castor-lib.i686', 'castor-devel.i686', 'mesa-libGL.i686',
                   'mesa-libGL-devel.i686', 'mesa-libGLU.i686',
                   'mesa-libGLU-devel.i686']:
          require => Class[Packagerepos],
          ensure => installed,
        }
      }
    }

    package { 'xrootd-client':
      ensure => installed,
    }
    # Subversion required for RootCore etc.
    package { 'subversion':
      ensure => installed,
    }
  }
}

