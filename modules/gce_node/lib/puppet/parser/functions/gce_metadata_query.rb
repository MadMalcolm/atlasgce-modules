 module Puppet::Parser::Functions
   newfunction(:gce_metadata_query, :type => :rvalue) do |args|
     require 'open-uri'
     uri = 'http://metadata/computeMetadata/v1beta1/' + args[0]
     result = open(uri).read
   end
 end
