Facter.add("cloud_name") do
  has_weight 100
  setcode do
    # Check for existance of '/var/lib/cloud_type' and check the cloud flavour
    if File.exists?('/var/lib/cloud_name')
      IO.read('/var/lib/cloud_name')
    end
  end
end
