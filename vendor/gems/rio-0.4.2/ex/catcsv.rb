#!/usr/local/bin/ruby

require 'rio'
require 'rio/argv'
# Concatonate all the CSV files in a directory, but only include the header
# line from one of them.
require 'optparse'
require 'optparse/time'
require 'ostruct'
require 'pp'

class CatCSVOptions
  
  #
  # Return a structure describing the options.
  #
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.outfile = nil
    
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: #{$0} [options] csv_directory"
      
      opts.separator ""
      opts.separator "Specific options:"
      
      opts.on("-o", "--output [OUTPUT_FILE]", "Specify the output CSV file") do |ofile|
        options.outfile = ofile
      end
      
      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
      
      # Print the version.
      opts.on_tail("--version", "Show version") do
        puts OptionParser::Version.join('.')
        exit
      end
    end
    
    opts.parse!(args)
    options
  end  # parse()
  
end 

options = CatCSVOptions.parse(ARGV)

csvdir = RIO.ARGV.shift
unless csvdir
  puts options
  exit
end
output_file = options.outfile ? rio(options.outfile) : rio(csvdir.filename + '.all.csv')

output_file << rio(csvdir).files['*.csv'][0][0] << rio(csvdir).skip.lines(0)

__END__
