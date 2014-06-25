# class: wlcg
#
# wlcg installes and configures the tools needed for operation within
# the Worldwide LHC Computing Grid
#
# Parameters:
#
#
# Actions:
#   - add cern's linuxsoft yum repository
#   - install HEP_OSlibs

class wlcg {

  # If not on CernVM install package
  if $osvariant == 'CernVM' {
    info('On CernVM - skipping HEP_OSlibs installation.')
  } elsif $osfamily == 'RedHat' {

    yumrepo { 'wlcg-sl6-repo':
      descr    => "WLCG Repository",
      baseurl  => 'http://linuxsoft.cern.ch/wlcg/sl6/$basearch',
      protect  => 1,
      enabled  => 1,
      gpgcheck => 0,
    }

    package { 'HEP_OSlibs_SL6':
      ensure  => installed,
      require => Yumrepo['wlcg-sl6-repo'],
    }

  }

}


