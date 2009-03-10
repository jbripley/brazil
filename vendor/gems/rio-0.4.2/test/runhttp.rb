#!/usr/local/bin/ruby
Dir.chdir File.dirname(__FILE__)
$:.unshift File.expand_path('../lib/')

require 'rio'
require 'lib/temp_server'


TempServer.run('runhttptests.rb')

#threads.each { |aThread|  aThread.join }
