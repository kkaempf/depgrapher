#
# rubigraph.rb
#
# Output dependency graph to UbiGraph server
#

module Repograph
  
class Output

  require 'rubigraph'
  def self.to_rubigraph graph, pool, with_edgelabels = true
    channel = STDOUT

    Rubigraph.init #"192.168.0.7"

    Rubigraph.clear

    vertexes = Hash.new
    
    graph.each_vertex do |node|

      v = Rubigraph::Vertex.new
      vertexes[node] = v
      solvable = pool.solvable node
      name = solvable.name
#      STDERR.puts "Vertex[#{node}]<#{v}> #{name}"  
      v.label = name
#      v.set_attribute(:fontfamily, "Times Roman")
      v.size = 1
      v.fontsize = 10
      v.fontcolor = "#808080"

#      v.color = "#303030" if node.name[0,3] == "lib"
#      v.color = "#F0D080" if node.name[0,4] == "perl"
#      v.color = "#D0FFD0" if node.name[0,5] == "yast2"

#     v.set_attribute(:fontsize, 10)
#     v.set_attribute(:size, 10)
      v.set_attribute(:color, "#e02020") if name[0,3] == "lib"
      v.set_attribute(:color, "#20e020") if name[0,4] == "yast"
      v.set_attribute(:color, "#e0e020") if name[0,5] == "gnome"
      v.set_attribute(:color, "#e020e0") if name[0,4] == "xorg"

    end

    # Hash of outgoing Edges
    # key: Node where Edge starts
    # value: Hash of <Node where Edge ends, Edge>
    #

    graph.each_vertex do |node|
      vfrom = vertexes[node]
      vfrom.fontsize = 24
      vfrom.fontcolor = "#F0F0F0"
      graph.each_adjacent(node) do |target|
	vto = vertexes[target]
#      STDERR.puts "Vertex[#{node}]<#{vfrom}> -> [#{target}]<#{vto}>"  
	
	e = Rubigraph::Edge.new(vfrom, vto) 
	e.set_attribute 'oriented', true
#	e.label = edge.name if with_edgelabels
	e.width = 2.0
#	e.strength = 0.1
#	e.set_attribute 'spline', true
#	e.color = edgecolor
    end
      vfrom.fontsize = 10
      vfrom.fontcolor = "#808080"
    end
  end
end

end
