#
# options.rb#
# Handle command line options for depgrapher.rb
#

module Repograph

  require 'getoptlong'

  class Options
  attr_reader :format
  attr_reader :repos
  attr_reader :install, :remove
  attr_reader :depth, :arch, :ignore_weaks
  attr_reader :itargets # install targets (array)
  attr_reader :rtargets # remove targets
  attr_reader :full # full graph (vs. decisions)
  
  def initialize
    @format = nil
    @repos = []
    @install = false
    @itargets = []
    @remove = false
    @rtargets = []
    @depth = 99999
    @arch = "i686"
    @ignore_weaks = false
    @full = false
  end
  
  def usage reason = nil
    STDERR.puts reason if reason
    STDERR.puts "Usage: depgrapher.rb --format {rubigraph,tlp,dot} --solv <solvfile> [--system <installed> --arch <arch> --ignore-weaks --full ]{--install|--remove} [<kind>:]<name>"
    exit 1
  end

  def parse
    options = GetoptLong.new(
			     [ "--format",  GetoptLong::REQUIRED_ARGUMENT ],
			     [ "--system",  GetoptLong::REQUIRED_ARGUMENT ],
			     [ "--solv",    GetoptLong::REQUIRED_ARGUMENT ],
			     [ "--depth",   GetoptLong::REQUIRED_ARGUMENT ],
			     [ "--install", GetoptLong::REQUIRED_ARGUMENT ],
			     [ "--remove",  GetoptLong::REQUIRED_ARGUMENT ],
			     [ "--arch",    GetoptLong::REQUIRED_ARGUMENT ],
			     [ "--debug",   GetoptLong::NO_ARGUMENT ],
			     [ "--full",    GetoptLong::NO_ARGUMENT ],
			     [ "--ignore-weaks", GetoptLong::NO_ARGUMENT ]
			     )

    begin
      options.each do |opt, arg|
	case opt
	when "--format":  @format = arg
	when "--solv":    @repos = arg.split ","
	when "--depth":   @depth = arg.to_i
	when "--install"
	                  @install = true
	                  @itargets = arg.split ","
	  usage "--install parameters missing" if @itargets.empty?
	when "--remove":
	                  @remove = true
	                  @rtargets = arg.split ","
	  usage "--remove parameters missing" if @rtargets.empty?
	when "--arch":    @arch = Arch.new arg
	when "--debug":   $debug += 1
	when "--ignore-weaks": @ignore_weaks = true
	when "--full":    @full = true
	else
	  STDERR.puts "Ignoring unrecognized option #{opt}"
	end
      end
    rescue
    end

    $debug = nil if $debug == 0

    @depth = 99999 if @depth == 0

    usage "--format parameter missing" unless @format
    usage "excessive arguments #{ARGV[0]}..." if ARGV.size > 1
    usage "--solv parameter missing" if repos.empty?
    usage "Specify --install or --remove" unless install||remove
    usage "--depth must be >= 0" if depth < 0
  end
end

end # module Repograph
