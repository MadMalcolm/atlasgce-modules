# ganglia manifest
#
# this sets up ganglia reporting to CERN's hn-grizzly. May
# need to set different cluster names for the different
# clouds.

$udp_recv_channel = [
  { port => 8649 },
]

$udp_send_channel = [
  { port => 8649, host => 'hn-grizzly.cern.ch', ttl => 2 },
]

$cluster_name = 'ATLAS Test Cloud'

$tcp_accept_channel = [
  {port => 8649},
]

class{ 'ganglia::gmond':
  cluster_name       => $cluster_name,
  cluster_owner      => 'unspecified',
  cluster_latlong    => 'unspecified',
  cluster_url        => 'unspecified',
  host_location      => 'CERN',
  udp_recv_channel   => $udp_recv_channel,
  udp_send_channel   => $udp_send_channel,
  tcp_accept_channel => $tcp_accept_channel,
}
