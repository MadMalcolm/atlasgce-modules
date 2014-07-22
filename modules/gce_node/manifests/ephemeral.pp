# TODO: The parameter list is not optimal; it requires that the directories
# are configured both here and for the individual services. It would be
# preferable to access service::homedir directly, but that requires some more
# thoughts.
class gce_node::ephemeral (
  $cloud_type,
  $cvmfs_cache = '/var/cache/cvmfs2',
  $condor_homedir = '/var/lib/condor',
)
{
  # Mounts for GCE
  if $cloud_type == 'gce' {
    mount_ephemeral { $cvmfs_cache:
      device => '/dev/vg00/lv_cvmfs'
    }

    mount_ephemeral { $condor_homedir:
      device => '/dev/vg00/lv_condor'
    }

    # Mounts for Nimbus
  } elsif $cloud_type == 'Nimbus' {
    mount_ephemeral { $condor_homedir:
      device => 'LABEL=blankpartition0',
      fstype => 'ext2',
    }
    # Mounts for OpenStack, EC2, etc.
  } else {
    mount_ephemeral { $condor_homedir:
      device => 'LABEL=ephemeral0',
    }
  }
}

define mount_ephemeral (
  $directory = $name,
  $device,
  $fstype = 'ext4',
)
{
  mount { $directory:
    ensure  => 'mounted',
    device  => $device,
    fstype  => $fstype,
    options => 'noatime,noauto',
    dump    => 1,
    pass    => 0,
    require => File[$directory],
  }
}
