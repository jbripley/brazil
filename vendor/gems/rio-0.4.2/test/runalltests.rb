#!/usr/bin/ruby
Dir.chdir File.dirname(__FILE__)
$devlib=File.expand_path('../lib/')
$:.unshift $devlib unless $:[0] == $devlib

$mswin32 = (RUBY_PLATFORM =~ /mswin32/)

require 'rio'
require 'test/unit'

require 'tc/all'
require 'ftp/all'
$trace_states = false
require 'test/unit/ui/console/testrunner'
require 'lib/temp_server.rb'
TempServer.run('runhttptests.rb')
#require 'test/unit/ui/tk/testrunner'
