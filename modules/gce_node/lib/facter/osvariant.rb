Facter.add("osvariant") do
  has_weight 100
  setcode do
    # Check for existance of '/etc/distro-release' and check if it's CernVM
    if File.exists?('/etc/distro-release')
      if IO.read('/etc/distro-release') =~ /CERN Virtual Machine/
        "CernVM"
      end
    end
  end
end
