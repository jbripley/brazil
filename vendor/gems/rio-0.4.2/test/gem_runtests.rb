#!/usr/bin/ruby
Dir.chdir File.dirname(__FILE__)
#$:.unshift File.expand_path('../lib/')

require 'rubygems'
require 'rio'


#require 'rio'
require 'test/unit'

require 'tc/all'
$trace_states = false
require 'test/unit/ui/console/testrunner'
#require 'test/unit/ui/tk/testrunner'
