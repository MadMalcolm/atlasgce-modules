#
# Required repositories for the RedHat OS family
#
class packagerepos::yumrepos {
  package { 'yum-plugin-priorities':
    ensure => installed,
  }

  yumrepo {
    "slc6-extras":
      descr    => "Scientific Linux CERN ${operatingsystemmajrelease} (SLC${operatingsystemmajrelease}) add-on packages",
      baseurl  => "http://linuxsoft.cern.ch/cern/slc${operatingsystemmajrelease}X/${architecture}/yum/extras/",
      gpgcheck => 0,
      enabled  => 1,
      protect  => 1;
    "slc6-rhcommon":
      descr    => "Scientific Linux CERN (SLC${operatingsystemmajrelease}) - RHCOMMON addons",
      baseurl  => "http://linuxsoft.cern.ch/cern/rhcommon/slc${operatingsystemmajrelease}X/${architecture}/yum/rhcommon/",
      gpgcheck => 0,
      enabled  => 1,
      protect  => 1;
    "epel":
      descr      => "Extra Packages for Enterprise Linux ${operatingsystemmajrelease} - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-${operatingsystemmajrelease}&arch=\$basearch",
      gpgcheck   => 0,
      enabled    => 1,
      priority   => 1,
      protect    => 1;
    "epel-testing":
      descr      => "Extra Packages for Enterprise Linux ${operatingsystemmajrelease} - Testing - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=testing-epel${operatingsystemmajrelease}&arch=$basearch",
      gpgcheck   => 0,
      enabled    => 1,
      failovermethod => 'priority',
      protect    => 1;
    "cvmfs":
      descr    => "CernVM packages",
      baseurl  => "http://cern.ch/cvmrepo/yum/cvmfs/EL/${operatingsystemmajrelease}/${architecture}",
      gpgcheck => 1,
      gpgkey   => 'https://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM',
      enabled  => 1,
      priority => 1,
      protect  => 1;
    "cvmfs-testing":
      descr    => "CernVM testing packages",
      baseurl  => "http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/${operatingsystemmajrelease}/${architecture}",
      gpgcheck => 1,
      gpgkey   => 'https://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM',
      enabled  => 1,
      priority => 99,
      protect  => 1;
    "htcondor":
      descr => "HTCondor Stable RPM Repository for Redhat Enterprise Linux ${operatingsystemmajrelease}",
      baseurl => "http://research.cs.wisc.edu/htcondor/yum/stable/rhel${operatingsystemmajrelease}",
      enabled => 1,
      gpgcheck => 0,
      priority => 1,
      protect  => 1;
  }
}
