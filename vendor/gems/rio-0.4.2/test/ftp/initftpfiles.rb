#!/usr/local/bin/ruby
Dir.chdir File.dirname(__FILE__)
$devlib=File.expand_path('../../lib/')
$:.unshift $devlib unless $:[0] == $devlib
require 'rio'
$testlib = rio($devlib)
$testlib.filename = 'test'
$:.unshift $testlib.to_s

require 'ftp/testdef'
Test::RIO::FTP::init_test_files()


exit
