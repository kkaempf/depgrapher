#
# solver.rb
#

module Repograph
  
class Solver

  require 'options'

  require 'satsolver'
  require 'ruleinfo'

  attr_reader :solver

  def initialize options
    pool = Satsolver::Pool.new
    pool.arch = options.arch
    options.repos.each do |solv|
      repo = pool.add_solv solv
      repo.name = File.basename solv
    end

    # what we're trying to install or remove
    request = pool.create_request
	
    @solver = pool.create_solver
    @solver.dont_install_recommended = true
    options.itargets.each { |target| request.install target }
    options.rtargets.each { |target| request.remove target }

    unless @solver.solve request
      STDERR.puts "\n\t*** Solving failed"
      i = 0
      @solver.each_problem( request ) do |p|
	i += 1
	j = 0
	p.each_ruleinfo do |ri|
	  j += 1
	  puts "#{i}.#{j}: #{ri.command_s} #{ri}"
	end
      end
      
      @solver = nil
    end

  end # initialize()


end # Solver

end # Repograph
