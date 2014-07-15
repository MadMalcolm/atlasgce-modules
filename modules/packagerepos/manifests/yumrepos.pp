#
# Required repositories for the RedHat OS family
#
class packagerepos::yumrepos {
  package { 'yum-plugin-priorities':
    ensure => installed,
  }

  yumrepo {
    "slc6-extras":
      descr    => "Scientific Linux CERN 6 (SLC6) add-on packages",
      baseurl  => "http://linuxsoft.cern.ch/cern/slc6X/${architecture}/yum/extras/",
      gpgcheck => 0,
      enabled  => 1,
      protect  => 1;
    "slc6-rhcommon":
      descr    => "Scientific Linux CERN (SLC6) - RHCOMMON addons",
      baseurl  => "http://linuxsoft.cern.ch/cern/rhcommon/slc6X/${architecture}/yum/rhcommon/",
      gpgcheck => 0,
      enabled  => 1,
      protect  => 1;
    "epel":
      descr      => "Extra Packages for Enterprise Linux 6 - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch",
      gpgcheck   => 0,
      enabled    => 1,
      priority   => 1,
      protect    => 1;
    "epel-testing":
      descr      => "Extra Packages for Enterprise Linux 6 - Testing - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=testing-epel6&arch=\$basearch",
      gpgcheck   => 0,
      enabled    => 1,
      failovermethod => 'priority',
      protect    => 1;
    "cvmfs":
      descr    => "CernVM packages",
      baseurl  => "http://cern.ch/cvmrepo/yum/cvmfs/EL/6/${architecture}",
      gpgcheck => 1,
      gpgkey   => 'https://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM',
      enabled  => 1,
      priority => 1,
      protect  => 1;
    "cvmfs-testing":
      descr    => "CernVM testing packages",
      baseurl  => "http://cern.ch/cvmrepo/yum/cvmfs-testing/EL/6/${architecture}",
      gpgcheck => 1,
      gpgkey   => 'https://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM',
      enabled  => 1,
      priority => 99,
      protect  => 1;
    "htcondor":
      descr => "HTCondor Stable RPM Repository for Redhat Enterprise Linux 6",
      baseurl => "http://research.cs.wisc.edu/htcondor/yum/stable/rhel6",
      enabled => 1,
      gpgcheck => 0,
      priority => 1,
      protect  => 1;
  }
}
