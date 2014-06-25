 module Puppet::Parser::Functions
   newfunction(:condor_user_array, :type => :rvalue) do |args|
     number_of_users = args[0].to_i
     users = [*1..number_of_users].collect { |i| "slot%02d" % i }
   end
 end
