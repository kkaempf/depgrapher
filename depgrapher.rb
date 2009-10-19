#!/usr/bin/ruby
#
# depgrapher.rb
#
# reads a 'solv' file (satsolver repo cache)
#  solves dependencies
#  and outputs graph data
#
#

require 'rubygems'

require 'options'
require 'solver'
require 'builder'
require 'output'

module Repograph

  $debug = 0

  # parse command line args, read input files

  options = Options.new
  options.parse
  
  STDERR.puts "Running with debug level #{$debug}" if $debug

  solver = Solver.new options
  exit 1 unless solver

  # solve dependencies

  graph = Builder.build( solver.solver, options.full )

  # output requested format
	
  Output.print graph, solver.solver.pool, options

end # module Repograph
