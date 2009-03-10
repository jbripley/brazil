#!/usr/local/bin/ruby
Dir.chdir File.dirname(__FILE__)
$devlib=File.expand_path('../lib/')
$:.unshift $devlib unless $:[0] == $devlib

$mswin32 = (RUBY_PLATFORM =~ /mswin32/)

require 'rio'

$trace_states = false
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"
  
  opts.on("-f", "--ftp", "Run FTP Tests") do |v|
    options[:ftp] = v
  end
  opts.on("-h", "--http", "Run HTTP Tests") do |v|
    options[:http] = v
  end
  opts.on("-s", "--std", "Run Standard Tests") do |v|
    options[:std] = v
  end
  opts.on("-a", "--all", "Run All Tests") do |v|
    options[:std] = v
    options[:ftp] = v
    options[:http] = v
  end
end.parse!

options[:std] = true if options.empty?

options.keys.each do |opt|
  case opt
  when :std
    require 'tc/all'
    require 'test/unit/ui/console/testrunner'
  when :http
    require 'lib/temp_server.rb'
    TempServer.new.run('runhttptests.rb')
  when :ftp
    require 'test/unit'
    require 'ftp/all'
    require 'test/unit/ui/console/testrunner'
  end
end

#require 'test/unit/ui/tk/testrunner'
#require 'test/unit/ui/fox/testrunner'
#Test::Unit::UI::Tk::TestRunner.run(TC_MyTest)
