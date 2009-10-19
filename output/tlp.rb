#
# tlp.rb
#
# Output dependency graph as .tlp format (for Tulip)
#

module Repograph
  
class Output

  def self.to_tlp graph, pool, with_edgelabels = true
    channel = STDOUT
    
    #
    # Nodes
    #
    channel.printf "(nodes"
    num = 1
    graph.each_vertex do |node|
      channel.printf " #{node}"
    end
    channel.puts ")"
    
    #
    # Edges
    #
    num = 0
    graph.each_edge do |source,target|
      num += 1
      channel.puts "(edge #{num} #{source} #{target})"
    end

    #
    # Colors
    #
    channel.puts '(property 0 color "viewColor"'
    channel.puts '  (default "(0,0,0,255)" "(0,0,0,0)")'
    channel.puts ')'
    #
    # Labels
    #
    channel.puts '(property 0 string "viewLabel"'
    channel.puts '  (default "" "")'
    graph.each_vertex do |node|
      solvable = pool.solvable node
      channel.puts "  (node #{node} \"#{solvable.name}\")"
    end
    channel.puts ")"

    #
    # Sizes
    #
    channel.puts '(property 0 string "viewSize"'
    channel.puts '  (default "(1.0,1.0,1.0)" "(1.0,1.0,1.0)")'
    channel.puts ")"
    
    #
    # Layout
    #
    channel.puts '(property 0 layout "viewLayout"'
    channel.puts '  (default "(0.0,0.0,0.0)" "()")'
    channel.puts ")"
    
    #
    # Selection
    #
    channel.puts '(property  0 bool "viewSelection"'
    channel.puts '(default "false" "false" )'
    channel.puts ')'
    
    #
    # Shape
    #
    channel.puts '(property  0 int "viewShape"'
    channel.puts '(default "1" "1" )'
    channel.puts ')'

    channel.puts '(property  0 string "viewTexture"
		   (default "" "" )
		  )'
    channel.puts '(displaying 
		   (glyph 0 (plugin "Cone"))
		   (glyph 1 (plugin "Cube"))
		   (glyph 2 (plugin "CubeOutLined"))
		   (glyph 3 (plugin "Cylinder"))
		   (glyph 4 (plugin "Sphere"))
		   (color "backgroundColor" "(65,65,65,0)")
		   (color "nodeBaseColor" "(255,0,0,0)")
		   (color "edgeBaseColor" "(0,85,255,0)")
		   (bool "_viewArrow" false)
		   (bool "_viewLabel" true)
		   (bool "_viewKey" false)
		   (bool "_viewStrahler" false)
		   (bool "_viewAutoScale" true)
		   (bool "_incrementalRendering" true)
		   (bool "_edgeColorInterpolate" true)
		   (uint "_viewColorEntry" 1)
		   (uint "_viewOrtho" 1)
		   (uint "_FontsType" 2)
		   (int "SupergraphId" 0)
		   (coord "sceneTranslation" "(0,0,0)")
		   (coord "sceneRotation" "(180,0,0)")
		   (coord "sceneScale" "(1.41,1.41847,1)")
		   (coord "sceneInvScale" "(1,0.99403,1.41)")
		   )'
    
  end
end # class

end # module
