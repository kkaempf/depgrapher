#
# builder.rb
#

module Repograph

  require 'rgl/adjacency'

  require 'satsolver'
  
  class Builder
    attr_reader :graph

private
  #
  # Build the decisions-based graph
  #
  # Returns graph
  #
  
  def self.build_decisions graph, solver

    solver.each_decision do |decision|
      
      # only install requests

      next unless decision.op == Satsolver::DECISION_INSTALL
#     STDERR.puts "Decision #{d} (#{d.op} #{d.solvable})"
	  
      rule = decision.ruleinfo
      next unless rule   # weak decisions don't have a rule ?!
      
      #	  STDERR.puts "\tRule #{rule.command_s}"
      
      case rule.command
      when Satsolver::SOLVER_RULE_JOB
	graph.add_vertex decision.solvable.id
	next
      when Satsolver::SOLVER_RULE_RPM_PACKAGE_REQUIRES
	src = rule.source
	src_id = src.id
	dst = decision.solvable
	dst_id = dst.id
	graph.add_vertex src_id
	graph.add_vertex dst_id
	graph.add_edge src_id, dst_id
      else
	STDERR.puts "Unhandled #{rule}"
      end
    end
    graph
  end # build_decisions()
    
    
  # Build the full dependency graph as RGL::DirectedAdjacencyGraph
  # I: Array of solvables
  # O: graph RGL::DirectedAdjacencyGraph

  def self.build_full graph, solver
    solver.transaction.each do |step|
      next unless step.type == Satsolver::STEP_INSTALL
      graph.add_vertex step.solvable.id
    end
    pool = solver.pool
    solver.transaction.each do |step|
      next unless step.type == Satsolver::STEP_INSTALL
      s = step.solvable
      # for each requirement
      s.requires.each do |r|
#	$stderr.puts "#{s} requires #{r}"
	# find providers
	pool.each_provider(r) do |p|
#	  $stderr.puts "\tprovided by #{p} ?"
	  # skip self-provides
	  next if p == s
	  # skip providers not in graph
	  next unless graph.has_vertex? p.id
	  graph.add_edge(s.id, p.id) unless graph.has_edge?(s.id,p.id)
    	end
      end
    end
    graph
  end


public
    def self.build( satsolver, full )
      @satsolver = satsolver
      @full = full
      @graph = RGL::DirectedAdjacencyGraph.new
      if full
	build_full @graph, @satsolver
      else
	build_decisions @graph, @satsolver
      end
    end
  end

end # Repograph
