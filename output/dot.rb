#
# dot.rb
#
# Output dependency graph as .dot format (for graphviz)
#

module Repograph
  
class Output

  def self.to_dot graph, pool, with_edgelabels = true
    channel = STDOUT
    channel.puts "digraph G {"
    channel.puts "  size=\"8.0, 11.0\";"
    channel.puts "  ratio=fill;"

# x -> y [style = {bold, solid, dotted, dashed}, label = ]

    graph.each_vertex do |node|
      solvable = pool.solvable node
      channel.puts "# Node '#{solvable.to_s}'"
      prefix = solvable.name.split(":")[0]
      case prefix
      when "package" :	nodeshape = "ellipse"
      when "patch"   : nodeshape = "diamond"
      when "pattern" : nodeshape = "box"
      when "product" : nodeshape = "house"
      else	       nodeshape = "ellipse"
      end
      channel.puts "node [ shape = #{nodeshape} ] \"#{solvable.name}\";"
    end
    graph.each_edge do |source,target|

#	case edge.reason.kind
#	when :requires : edgecolor = "black"
#	when :provides
#	  next
#	when :recommends, :supplements
#	  next
#	  next if $ignore_weaks
	  edgecolor = "blue"
#	when :suggests, :enhances : edgestyle = "green"
#	  next
#	else edgecolor = "red"
#	end
	edgelabel = " [ color = \"#{edgecolor}\""
#	edgelabel += ", label=\"#{edge.name}\"" if with_edgelabels
	edgelabel += "]"
	channel.puts "\"#{pool.solvable(source).name}\" -> \"#{pool.solvable(target).name}\"#{edgelabel};"
    end
    
    channel.puts "}"
  end
end

end
