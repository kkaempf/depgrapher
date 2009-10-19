#
# output.rb
#

module Repograph
  
  class Output
    
    require 'builder'
    require 'output/dot'
    require 'output/tlp'
    require 'output/rubigraph'
    
    def self.print graph, pool, options
      case options.format
      when "rubigraph"
	Output.to_rubigraph graph, pool, options
      when "tlp"
	Output.to_tlp graph, pool, options
      when "dot",nil
	Output.to_dot graph, pool, options
      else
	STDERR.puts "Unknown --format value '#{format}'"
      end
    end
    
  end
  
end # module Repograph