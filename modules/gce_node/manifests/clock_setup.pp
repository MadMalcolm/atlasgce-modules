class gce_node::clock_setup (
  $hw_utc     = 'true',
  $clock_file = '/etc/sysconfig/clock'
)
{
  file {$clock_file:
    ensure  => present,
    owner   => root,
    group   => root,
    content => template("gce_node/sysconfig.clock.erb"),
  }
}
