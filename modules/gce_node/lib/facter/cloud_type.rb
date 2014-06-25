Facter.add("cloud_type") do
  has_weight 100
  setcode do
    # Check for existance of '/var/lib/cloud_type' and check the cloud flavour
    if File.exists?('/var/lib/cloud_type')
      IO.read('/var/lib/cloud_type')
    end
  end
end
