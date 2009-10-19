#
# Visualize package install
#


# Graph algorithms
#
# transitive sort
#

require 'rubygems'
require 'rgl/adjacency'
require 'rgl/bidirectional'
require 'rgl/transitivity'
require 'rgl/connected_components'
require 'rgl/topsort'
require 'rgl/dot'
  

#
# Package dependency solving
#

require 'satsolver'

def solve package
  pool = Satsolver::Pool.new
  pool.arch = "x86_64"
  repo = pool.add_solv( "full.solv" )
  repo.name = "OpenSUSE 11.1"

  # install 'yast2-installation'

  t = pool.create_transaction
  t.install package
  
  solver = pool.create_solver
  solver.dont_install_recommended = true
  res = solver.solve(t)
  return solver if res
  nil
end


#
# rUbiGraph drawing
#

$:.unshift("../lib")
require 'rubigraph'
  
def draw_start package

  begin
    Rubigraph.init #"10.10.0.65"
    Rubigraph.clear
  rescue Exception => e
    puts "Can't find Ubigraph server (#{e})"
    exit
  end

  title = Rubigraph::Vertex.new
  title.set_attribute(:shape, "none")
  title.set_attribute(:fontfamily, "Helvetica")
  title.set_attribute(:fontsize, 48)
  title.set_attribute(:fontcolor, "#faa900")
  
  title.set_attribute(:label, "Installing #{package}")
  sleep 2
  title.remove

end

#
# draw vertex 's' of graph
#  drawn: Hash of already drawn vertexes (Rubigraph::Vertex)
#

def draw_vertex graph, v
    puts "Draw #{v.inspect}"
  vertex = v[:vertex]
  unless vertex
    vertex = Rubigraph::Vertex.new
    v[:vertex] = vertex
  end
#  vertex.set_attribute(:visible, false)
  isize = (v[:solvable]['solvable:installsize'] + 1023) / 1024 + 1
  vertex.set_attribute(:label, "#{v[:solvable].name}")
#  vertex.set_attribute(:color, "#808080")
  vertex.set_attribute(:fontcolor, "#ffffff")
  vertex
#  true
end

def draw_edge graph, from, to
  return if from[:solvable] == to[:solvable]
  puts "#{from.inspect} -> #{to.inspect}"
  e = Rubigraph::Edge.new( from[:vertex], to[:vertex] )
  e.set_attribute(:oriented, true)
  e.set_attribute(:color, "#ffffff")
  e.set_attribute(:width, from[:outgoing][to[:name]])
  e.set_attribute(:strength, 0.0)
  e
end

def draw_graph graph, data
  cycles = Array.new
#  unless graph.acyclic?
#    puts "Finding cycles ..."
#    cycles = graph.cycles
#    puts "Found #{cycles.size} cycles:"
#    cycles.each do |c|
#      puts "Cycle #{c.inspect}"
#    end
#  end
  RGL::TopsortIterator.new(graph).reverse_each do |v|
    vertex = draw_vertex( graph, data[v] )
#    vertex.set_attribute(:fontsize, 48)
#    vertex.set_attribute(:fontcolor, "#ffffff")
#    vertex.set_attribute(:color, "#ffffff")
    graph.each_adjacent(v) do |u|
      otherv = data[u][:vertex] || draw_vertex( graph, data[u] )
#      otherv.set_attribute(:fontsize, 48)
#      otherv.set_attribute(:fontcolor, "#faa900")
      draw_edge graph, data[v], data[u]
#      sleep 0.5
#      otherv.set_attribute(:fontcolor, "#000000")
#      otherv.set_attribute(:fontsize, 10)
    end
    sleep 1
#    vertex.set_attribute(:fontcolor, "#404040")
#    vertex.set_attribute(:color, "#c0c0c0")
#    vertex.set_attribute(:fontsize, 12)
  end
end

#------------------------------------

package = ARGV.shift
raise "Usage: install <package>" unless package

puts "Computing #{package}"
solver = solve package
raise "Cannot solve" unless solver

solvables = Array.new
solver.each_to_install do |s|
  solvables << s
end
  
puts "Building graph"
# build full dependency graph and collect data
graph,data = build_graph solvables


puts "Graph\n#{data.inspect}"
#puts "\nReduced\n#{graph.transitive_reduction}"
#exit

#
# Graph
#

draw_start package

puts "Drawing graph"
draw_graph graph.transitive_reduction, data
#draw_graph graph, data
