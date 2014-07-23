Facter.add("central_manager") do
  has_weight 100
  setcode do
    # Get CONDOR_HOST from '/etc/condor/central_manager' or default to localhost
    if File.exists?('/etc/condor/central_manager')
      IO.read('/etc/condor/central_manager').chomp
    else
      "localhost"
    end
  end
end
